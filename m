Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2LLMNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:13:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44586 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab2LLMNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:13:48 -0500
Date: Wed, 12 Dec 2012 13:13:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50
 [snd_hda_intel] returns -11
Message-ID: <20121212121345.GB8760@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	lkml <linux-kernel@vger.kernel.org>,
	Linux PM list <linux-pm@vger.kernel.org>
References: <20121211170315.GC28827@liondog.tnic>
 <2487425.bAQggRZzC4@vostro.rjw.lan>
 <20121211175508.GE28827@liondog.tnic>
 <15066310.xXEWfqCuJc@vostro.rjw.lan>
 <s5hhanrh6zi.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hhanrh6zi.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 11:58:41AM +0100, Takashi Iwai wrote:
> Borislav, could you test the patch below?

[ … ]

> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Move runtime PM check to runtime_idle callback
> 
> The runtime_idle callback is the right place to check the suspend
> capability, but currently we do it wrongly in the runtime_suspend
> callback.  This leads to a kernel error message like:
>    pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50 [snd_hda_intel] returns -11
> and the runtime PM core would even repeat the attempts.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>

	  -and-tested-by: ...

Thanks Takashi.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0IVORZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:17:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0IVORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:17:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] SOUND-OSS: Remove sh_dac_audio
Date: Wed, 22 Sep 2010 16:17:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, ralf@linux-mips.org,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <1285156021-4973-1-git-send-email-jkacur@redhat.com> <20100922124747.GD9546@linux-sh.org>
In-Reply-To: <20100922124747.GD9546@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221617.00195.arnd@arndb.de>
X-Provags-ID: V02:K0:eCf6I/miKWtEbm0hNXOLdXgZ1xce6upNprVIdVAzuXo
 FEz/tSShzzKdZsqvuOf61tuaXZVdlhmABzooGUpJom+Bfrsdpf
 7Wa8fzJRmZ5LjnFbBqzf6A9eMQwQrXNIL1qHNMchK9GhjWZnbs
 KOq3EUOaIeAVrr6cQVQDW1UjUsHImZjJLkwUisuWouDgAKZPS7
 KWda7sihQeD810no4SFfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 September 2010, Paul Mundt wrote:
> On Wed, Sep 22, 2010 at 01:47:01PM +0200, John Kacur wrote:
> > Remove the SH DAC oss driver since there is an equivalent alsa driver.
> > oss has been deprecated for years. Furthermore this driver has BKL code
> > which we are trying to remove. Rather than attempt to fix this, simply
> > remove the driver.
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> 
> Since I thought I had already removed this ages ago but appear to have
> been imagining things:
> 
> Acked-by: Paul Mundt <lethal@linux-sh.org>

Oh well, nevermind my comment about keeping it then.

	Arnd

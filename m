Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0E3Pqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:46:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45463 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab0E3Pqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:46:30 -0400
Date: Sun, 30 May 2010 17:46:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: current git kernel crashes UML system during boot
Message-ID: <20100530154627.GB1565@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	Borislav Petkov <borislav.petkov@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	user-mode-linux-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <201005271944.09541.toralf.foerster@gmx.de>
 <AANLkTimYeMO_fc8C5MQedwF646_au4lvEbXkBPmQSxb9@mail.gmail.com>
 <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
 <20100530150214.GA1565@liondog.tnic>
 <AANLkTimo-kuzlyQvraLnYBZKlGQHr23ZiMeWmTaj4Yea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimo-kuzlyQvraLnYBZKlGQHr23ZiMeWmTaj4Yea@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, May 30, 2010 at 05:18:21PM +0200

> Works, thanks!
> 
> BTW, if you want to check yourself:
> 
>     make ARCH=um defconfig
>     make ACH=um
>     ./linux
> 
> If it panics because it cannot mount the root file system, it works.

Cool, thank you both for testing. I'll add your Tested-by:'s.

-- 
Regards/Gruss,
    Boris.

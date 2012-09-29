Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab2I2Wbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 18:31:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49102 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab2I2Wbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 18:31:39 -0400
Date: Sun, 30 Sep 2012 00:31:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Franklin Wei <frankhwei536@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: arch/x86/lib/inat.c Error and Kernel Panic
Message-ID: <20120929223136.GA10419@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Franklin Wei <frankhwei536@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@redhat.com>
References: <CAEMuUzi2SHp8Z44R4=B8EhutBuODRfoK5uWVaGfTU=Mf-XeqAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEMuUzi2SHp8Z44R4=B8EhutBuODRfoK5uWVaGfTU=Mf-XeqAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 09:36:36AM -0400, Franklin Wei wrote:
> Well, I managed to compile the kernel (3.6rc7) using the code in the
> tar.gz. However, when I try to boot it, it gives a kernel panic. I
> suspect that it has to do with the initrd I created, judging from the
> messages on the screen. Attached are pictures of the error. Sorry fot
> the bad quality.
> You guys are awesome!

Not yet, we haven't fixed your issue yet :)

But judging from the screenshots, you don't have the required drivers
for the kernel to find your root partition.

Make sure you've compiled in the SATA/IDE driver for your motherboard
and the driver for your root filesystem (ext2,3,4). When you have all
those compiled into the kernel you don't need an initrd AFAICT.

Simply try booting a live cd, see what SATA/IDE driver gets detected,
enable it in your kernel and then try again.

Or take the .config from an older kernel which boots on your box.

HTH.

-- 
Regards/Gruss,
    Boris.

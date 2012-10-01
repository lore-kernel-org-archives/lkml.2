Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2JAWWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:22:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39601 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2JAWWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:22:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120929223136.GA10419@liondog.tnic>
References: <CAEMuUzi2SHp8Z44R4=B8EhutBuODRfoK5uWVaGfTU=Mf-XeqAQ@mail.gmail.com>
	<20120929223136.GA10419@liondog.tnic>
Date: Mon, 1 Oct 2012 18:22:29 -0400
Message-ID: <CAEMuUzhiqorMnVj9q+Gt2GgOKH39vQU5_SqYZM8ciUSGBzkFRg@mail.gmail.com>
Subject: Re: arch/x86/lib/inat.c Error and Kernel Panic
From: Franklin Wei <frankhwei536@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Franklin Wei <frankhwei536@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll take your advice. However, this is a MacBook so...
Thanks anyways!

On 9/29/12, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Sep 29, 2012 at 09:36:36AM -0400, Franklin Wei wrote:
>> Well, I managed to compile the kernel (3.6rc7) using the code in the
>> tar.gz. However, when I try to boot it, it gives a kernel panic. I
>> suspect that it has to do with the initrd I created, judging from the
>> messages on the screen. Attached are pictures of the error. Sorry fot
>> the bad quality.
>> You guys are awesome!
>
> Not yet, we haven't fixed your issue yet :)
>
> But judging from the screenshots, you don't have the required drivers
> for the kernel to find your root partition.
>
> Make sure you've compiled in the SATA/IDE driver for your motherboard
> and the driver for your root filesystem (ext2,3,4). When you have all
> those compiled into the kernel you don't need an initrd AFAICT.
>
> Simply try booting a live cd, see what SATA/IDE driver gets detected,
> enable it in your kernel and then try again.
>
> Or take the .config from an older kernel which boots on your box.
>
> HTH.
>
> --
> Regards/Gruss,
>     Boris.
>

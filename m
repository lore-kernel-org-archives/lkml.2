Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2HUHWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:22:09 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:52620 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab2HUHWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:22:07 -0400
Message-ID: <5033371C.9040703@msgid.tls.msk.ru>
Date: Tue, 21 Aug 2012 11:22:04 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Tomas Racek <tracek@redhat.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, kvm-devel <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>
Subject: Re: [Qemu-devel] x86, nops settings result in kernel crash
References: <1466897901.2256382.1345482795440.JavaMail.root@redhat.com>
In-Reply-To: <1466897901.2256382.1345482795440.JavaMail.root@redhat.com>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.2012 21:13, Tomas Racek wrote:
[]
Can we trim the old, large and now not-so-relevant discussion please? ;)

> I can provide you with more different traces if it can help. But I thought that maybe it will be more useful for you to try it on your own. So I've prepared some minimal debian installation which you could download here (apx 163M bzipped):
> 
> http://fi.muni.cz/~xracek/debian.img.bz2
> 
> Password:
> root/asdfgh
> 
> Here is my config for guest kernel:
> 
> http://fi.muni.cz/~xracek/config
> 
> I use
> 
> qemu-kvm -m 1500 -hda debian.img -kernel linux/arch/x86/boot/bzImage -append "root=/dev/sda1"

Um.  I'd expect the image to be self-contained, no external kernel.
I wanted to do a quick test to see if it fails on my machine too,
d/loaded debian.img.bz2 but there's no kernel.  So.. no quick test
for you ;)

> After logging in just run "sh runtest.sh". This leads to crash in my case (host: Intel Core i5-2540M, kernel 3.5.2-1.fc17.x86_64, qemu 1.0.1).

With all the above, this "runtest.sh" is informationally equal to
your disk image.

/mjt

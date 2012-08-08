Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2HHIJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:09:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61892 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab2HHII3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:08:29 -0400
Message-ID: <50221E7A.70003@zankel.net>
Date: Wed, 08 Aug 2012 01:08:26 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Vadim Malenboim <vadim@tangotec.com>
CC: Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org,
        Kirill Krinkin <kirill.krinkin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Linux-Xtensa] Re: xtensa port maintenance
References: <50205592.1030205@gmail.com> <5020AA5B.4080407@zankel.net> <CAJH6qSc=Xffk85To2wZ=Ynw41Wb385XEpcT_OGjPV7r=i7M+UQ@mail.gmail.com>
In-Reply-To: <CAJH6qSc=Xffk85To2wZ=Ynw41Wb385XEpcT_OGjPV7r=i7M+UQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vadim,

On 08/06/2012 11:00 PM, Vadim Malenboim wrote:
> Hi All,
>
> I've beed dealing with the xtensa port for couple of months and I'd 
> like to contribute / help as much as possible.
>
> I have an ML605 Xilinx Evaluation Board and already succeeded running 
> the clean-stable version from xtensa-linux on it.
>
> I propose doing the testing on this board and any other tasks / issues 
> you think I can help, I'd be glad to.

Excellent!! I'm looking forward to your help.

-Chris

>
> Vadim.
>
> On Tue, Aug 7, 2012 at 8:40 AM, Chris Zankel <chris@zankel.net 
> <mailto:chris@zankel.net>> wrote:
>
>     Hi Max,
>
>
>     On 08/06/2012 04:38 PM, Max Filippov wrote:
>
>         AFAIK xtensa linux port is currently in bad shape: it doesn't
>         work in the
>         mainline, it fails to build in the linux-next. The latest
>         working kernels for
>         xtensa are 2.6.29...31 trees hosted at the
>         git.linux-xtensa.org <http://git.linux-xtensa.org>.
>
>     I wouldn't say it's in bad shape, I just built an vmlinux image
>     from the latest tree (3.6.0-rc1), but it might not be very stable.
>     One of the major issues is not really the kernel but  there's
>     actually no way to build a fairly recent version of the toolchain.
>     I have been using a somewhat more recent buildroot version than
>     what is on xtensa-linux.org <http://xtensa-linux.org>, but even
>     that version of buildroot is rather old now and needed a few patches.
>
>     The tree on linux-xtensa.org <http://linux-xtensa.org> has quite
>     diverted from mainline now. Pete has done a great job maintaining
>     those kernel versions, fixing a lot of bugs, and adding a ton of
>     new additional features, but it will take quite some effort to
>     merge them with the latest kernel.
>
>
>         I have a goal to make xtensa arch in the linux mainline usable.
>
>     Awesome!! Every help is very much appreciated.
>
>
>         Currently I have a number of patches on top of Linus' tree
>         that allow to build
>         working allnoconfig, defconfig and allmodconfig kernels for
>         ISS machine with
>         dc232b and fsf core variants [1]. For the next several weeks
>         I'm planning to
>
>     You might expect that I'm more than curious to see those changes :-)
>
>
>
>         forward-port patches accumulated in linux-xtensa.org
>         <http://linux-xtensa.org> git trees and make the
>         resulting kernels rock-solid. I'd like to restore xtensa
>         participation in the
>         linux-next. Further (currently undetailed) plans are to bring
>         modern Linux
>         features to the xtensa port, e.g. device trees.
>
>     That would be great. Might I also add that we'd need to have a
>     working toolchain and bootable image. For me, buildroot seems to
>     be the quickest route here. That would also require possibly
>     adding patches to the toolchain and uClibc that are currently
>     missing. There's also the bootloader, etc.
>
>
>         I have a couple of questions regarding the path of
>         xtensa-specific patches
>         upstream:
>              - which git tree should they be targeted for? Should I
>         set up a tree for
>                pull requests, or will patches be picked up into some
>         existing tree?
>                (Looks like Linus' tree is the right target. AFAIK
>         previously xtensa
>                patches went mostly through akpm tree).
>
>     Yes, Andrew has been very helpful stepping in and adding those
>     patches. Most if not all of those patches were fixes because of
>     generic kernel changes and not major fixes or changes to the core
>     of the Xtensa port.
>
>     Ideally, it would be great if you could create a git tree (I saw
>     you already have a version on github already?) that would allow us
>     to look over those patches. The goal should be to have a system to
>     build toolchain, bootable image, and kernel, so we can run some
>     regression tests on either the simulator (qemu) or an actual
>     board. Once we have a regression test system in place, we can then
>     add more features and funnel those patches either through me or
>     more directly..
>
>     What do you think?
>
>     If you already have such a system in place, it would be great if
>     you could send me some instructions to recreate it locally. We can
>     give you also access to the wiki to add any information there.
>
>
>              - which mailing lists should they go to?
>                (I guess that besides linux-xtensa@linux-xtensa.org
>         <mailto:linux-xtensa@linux-xtensa.org> list they should go
>                to linux-kernel@vger.kernel.org
>         <mailto:linux-kernel@vger.kernel.org> for general review.
>         Anything else?)
>
>     For now, I would really appreciate if you could hold off sending
>     any major patch to the linux-kernel mailing list until we had a
>     chance to look over them unless it's some generic patch (fixing an
>     issue because of an API change to the kernel, etc.)
>
>     Andrew is currently adding all Xtensa patches sent to that list,
>     and I would hate having to irritate him having to ask to remove or
>     change patches, etc.
>
>
>         Should you wonder what I am:
>         I am a member of St.Petersburg Open Source and Linux Lab [2].
>         My previous contributions to Linux are related to p54spi
>         wireless driver.
>         I'm also a developer and maintainer of the target-xtensa QEMU
>         port [3].
>
>     That's so great!! I didn't know there was a QEMU port for Xtensa.
>
>     Bottom line, I hope you agree with me that the kernel, although
>     the most fun part, is only one piece of the puzzle, and we also
>     need a running system. If you already have that in place, we can
>     jump to the kernel fairly quickly.
>
>     Thanks,
>     -Chris
>
>
>     _______________________________________________
>     linux-xtensa mailing list
>     linux-xtensa@linux-xtensa.org <mailto:linux-xtensa@linux-xtensa.org>
>     http://lists.linux-xtensa.org/mailman/listinfo/linux-xtensa
>
>
>
>
> -- 
> *Vadim Malenboim.*
>       Low Level Software Engineer.
>
>       Cellular : +972(544)925862
>       E-Mail   : vadim@tangotec.com <mailto:vadim@tangotec.com>
>       WEB     : www.tangotec.com <http://www.tangotec.com>
>
>


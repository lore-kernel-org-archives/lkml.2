Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab0FQLSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:18:20 -0400
Received: from ossa.mas.viperplatform.net.au ([202.147.75.25]:38767 "EHLO
	ossa.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893Ab0FQLSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:18:18 -0400
X-Greylist: delayed 1830 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2010 07:18:18 EDT
Date: Thu, 17 Jun 2010 20:47:40 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: Wu <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: Re: [PATCH v4 00/16] Cleanup Lemote FuLoong2e Support
Message-ID: <20100617104735.GC24561@www.longlandclan.yi.org>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Thu, Jul 02, 2009 at 11:15:52PM +0800, Wu wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
>
> This patch series is the -v4 version of the loongson-PATCH-v3 series, but it
> only include the cleanup for fuloong2e support and necessary preparation for
> future fuloong-2f and yeeloong-2f support.
>
> The git branch of this patch series is:
>
> 	git://dev.lemote.com/rt4ls.git linux-loongson/dev/fuloong2e
>
> 	or
>
> 	http://dev.lemote.com/cgit/rt4ls.git/log/?h=linux-loongson/dev/fuloong2e

stuartl@duron ~/linux-fulong2e $ git fetch rt4ls
remote: Counting objects: 476834, done.
remote: Compressing objects: 100% (90281/90281), done.
remote: Total 452782 (delta 393459), reused 411290 (delta 359631)
Receiving objects: 100% (452782/452782), 152.90 MiB | 50 KiB/s, done.
Resolving deltas: 100% (393459/393459), completed with 15512 local
objects.
>From git://dev.lemote.com/rt4ls
 * [new branch]      linux-loongson/2.6.29/rt-preempt ->
 			rt4ls/linux-loongson/2.6.29/rt-preempt
 * [new branch]      linux-loongson/2.6.29/stable ->
			rt4ls/linux-loongson/2.6.29/stable
 * [new branch]      linux-loongson/2.6.30/stable ->
			rt4ls/linux-loongson/2.6.30/stable
 * [new branch]      linux-loongson/2.6.31/rt-preempt ->
			rt4ls/linux-loongson/2.6.31/rt-preempt
 * [new branch]      linux-loongson/2.6.31/stable ->
			rt4ls/linux-loongson/2.6.31/stable
 * [new branch]      linux-loongson/2.6.32/stable ->
			rt4ls/linux-loongson/2.6.32/stable
 * [new branch]      linux-loongson/2.6.33/stable ->
			rt4ls/linux-loongson/2.6.33/stable
 * [new branch]      linux-loongson/dev/2.6.30-gdium ->
			rt4ls/linux-loongson/dev/2.6.30-gdium
 * [new branch]      linux-loongson/dev/2.6.33-gdium ->
			rt4ls/linux-loongson/dev/2.6.33-gdium
 * [new branch]      linux-loongson/dev/kft ->
			rt4ls/linux-loongson/dev/kft
 * [new branch]      linux-loongson/dev/kgcov ->
			rt4ls/linux-loongson/dev/kgcov
 * [new branch]      master     -> rt4ls/master
 * [new branch]      rt/2.6.31/loongson -> rt4ls/rt/2.6.31/loongson
 * [new branch]      rt/2.6.31/mips -> rt4ls/rt/2.6.31/mips
 * [new branch]      rt/2.6.33/loongson -> rt4ls/rt/2.6.33/loongson
...

I can't seem to find a linux-loongson/dev/fuloong2e branch... did I miss
the boat?  I'm looking to update the kernels on the two Fulongs 2Es
here... as I'm having grief compiling Python 2.6 -- hard locks always at
the same point, and I have a feeling it's the
kernel+kernel-build-toolchain combo that's possibly to blame.

Regards,
--
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.

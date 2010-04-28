Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0D1Vql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:46:41 -0400
Received: from www.tglx.de ([62.245.132.106]:44553 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab0D1Vqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:46:40 -0400
Date: Wed, 28 Apr 2010 23:46:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
In-Reply-To: <x2oe6bf505b1004281422m41f96ec4zf98a94a321d78ba2@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004282339330.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>  <1272400246.2255.5.camel@localhost>  <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>  <1272434481.1974.101.camel@work-vm>  <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>
  <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain>  <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>  <alpine.LFD.2.00.1004282137330.2951@localhost.localdomain>  <g2we6bf505b1004281306sa6ddb207p7a1b8853c3ab308f@mail.gmail.com> 
 <alpine.LFD.2.00.1004282218470.2951@localhost.localdomain> <x2oe6bf505b1004281422m41f96ec4zf98a94a321d78ba2@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Xianghua Xiao wrote:
> On Wed, Apr 28, 2010 at 3:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Can you please decode the code lines with
> >
> > # addr2line -e vmlinux 0xc009ca1c 0xc009c9cc
> >
> > You need to enable CONFIG_DEBUG_INFO to get real line numbers.
> 
> # reboot
> # Oops: Kernel access of bad area, sig: 11 [#1]
> PREEMPT 834x SYS
> Modules linked in:
> NIP: c009ded8 LR: c009de88 CTR: 00000000

Again. Can you please decode the code lines with

# addr2line -e vmlinux 0xc009ded8 0xc009de88

Please run the above shell command in the directory where your kernel
compile output resides. If you compiled with O=BUILD_DIR then cd to
$BUILD_DIR otherwise you will find vmlinux in the root of your kernel
source tree. Please provide the output.

Thanks,

	tglx

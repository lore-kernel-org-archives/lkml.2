Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2BOWsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:48:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2BOWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:48:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Date: Wed, 15 Feb 2012 22:14:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
        "kvm-ppc" <kvm-ppc@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4F2AB552.2070909@redhat.com> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de>
In-Reply-To: <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202152214.24992.arnd@arndb.de>
X-Provags-ID: V02:K0:urp3NOcjygWA888OeAVle50ahfAqZ0DBMUfFUQ9O1CN
 4aA8m7pFCOWZGG9MNTUM1yIrUoTmWqtFC0NY40UVAWQaPYAfW/
 YTdmdAjZlkCukWkQhz10sW7UzU5nGPjVO+4nc5O4/ENG2GMurw
 mYPKwm4lBsKUQIothHAs0NTJMabSFUDnm0k1IqeIb38od40dHV
 JeJWYPjg6ZfLPEqQZ3hdhtQYv4G70Zuo49zc51fL0CLLxM2kcE
 P+i/8zRXm7Y1+db5IXzNRBP6hE85GGriYvRbxPZkn6RpTMztRe
 F59dEELUd7MNGLZ/1NvqRwB9WR/tC/dl83h4/kOnmZjOBmJbK8
 5JUaRHUTXgeEip2telRw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 February 2012, Alexander Graf wrote:
> >> 
> >> Not sure we'll ever get there. For PPC, it will probably take another 1-2 years until we get the 32-bit targets stabilized. By then we will have new 64-bit support though. And then the next gen will come out giving us even more new constraints.
> > 
> > I would expect that newer archs have less constraints, not more.
> 
> Heh. I doubt it :). The 64-bit booke stuff is pretty similar to what we have today on 32-bit, but extends a
> bunch of registers to 64-bit. So what if we laid out stuff wrong before?
> 
> I don't even want to imagine what v7 arm vs v8 arm looks like. It's a completely new architecture.
> 

I have not seen the source but I'm pretty sure that v7 and v8 they look very
similar regarding virtualization support because they were designed together,
including the concept that on v8 you can run either a v7 compatible 32 bit
hypervisor with 32 bit guests or a 64 bit hypervisor with a combination of
32 and 64 bit guests. Also, the page table layout in v7-LPAE is identical
to the v8 one. The main difference is the instruction set, but then ARMv7
already has four of these (ARM, Thumb, Thumb2, ThumbEE).

	Arnd


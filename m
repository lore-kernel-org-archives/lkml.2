Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0EQJCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:02:15 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:30371 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0EQJCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:02:14 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+3aIibppu0283rgF+SkOizsxsoR83
X-RZG-CLASS-ID: mo00
Date: Mon, 17 May 2010 11:02:11 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: qemu/nfsroot: BUG: sleeping function called from invalid
 context at 2.6.33.3-rt19-i686-pc/kernel/rtmutex.c:684
Message-ID: <20100517090211.GA7431@aepfle.de>
References: <20100516213333.GA27132@aepfle.de>
 <alpine.LFD.2.00.1005171018100.3368@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005171018100.3368@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, Thomas Gleixner wrote:

> On Sun, 16 May 2010, Olaf Hering wrote:
> > 
> > Running 2.6.33.3-rt19 in qemu with nfsroot floods dmesg with lots of
> > warnings like
> > 
> > BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
> > 
> > This happens already when the kernel mounts the nfsroot filesystem,
> > if I interpret the dmesg output below correctly.
> > 
> > Any idea how to fix the reported BUG?
> 
> Yup, patch below should do the trick. It fixes the other user of this
> as well.

Yes, no BUG flood with this patch applied.
Thanks.

Olaf

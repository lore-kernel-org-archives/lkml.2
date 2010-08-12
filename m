Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab0HLAPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:15:07 -0400
Received: from www.tglx.de ([62.245.132.106]:47122 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986Ab0HLAO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:14:56 -0400
Date: Thu, 12 Aug 2010 02:14:54 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Tom Lyon <pugs@cisco.com>,
        mst@redhat.com, gregkh@suse.de, chrisw@sous-sol.org, joro@8bytes.org,
        avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: UIO DMA to userspace question
Message-ID: <20100812001453.GC6411@local>
References: <AANLkTimWdaBrJz-dQ3MHWwG7iZ5m1opSmLFKva880csi@mail.gmail.com>
 <20100809111155.GB2569@local>
 <20100810001244.GD2569@local>
 <AANLkTingmHe9z6KLp_euogxbXCTCZN+DMs2oEpC6VDKn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTingmHe9z6KLp_euogxbXCTCZN+DMs2oEpC6VDKn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 08:42:35PM +0200, Leon Woestenberg wrote:
[...]
> 
> I am currently refraining from using UIO, as I don't like the head
> ache feature :-)

Well, if you need feature X, capability Y, or usecase Z, feel free to send
patches.

I (and several of my colleagues) wrote quite a lot of UIO drivers for
various chips in the last 4 years. I never had a device that needed DMA
on my desk yet, otherwise support for it would be in mainline now.

UIO was mainly invented to prevent people from writing large character
device drivers that will never make it to mainline, and then having to
maintain them off-tree. It is not a general purpose driver interface
but a small framework to handle a special class of hardware that doesn't
fit into any other subsystem. If you've got such hardware, and you need
a certain feature, think about how it can be done, and let us know.

Thanks,
Hans

> 
> Regards,
> -- 
> Leon

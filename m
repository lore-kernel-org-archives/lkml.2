Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1GHIIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:08:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49747 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1GHIIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:08:11 -0400
Date: Fri, 8 Jul 2011 09:07:51 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Qin Dehua <qindehua@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, neilb@suse.de
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause
	OOPS
Message-ID: <20110708080751.GA14947@flint.arm.linux.org.uk>
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com> <20110630074301.GC27959@flint.arm.linux.org.uk> <BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com> <20110630112804.GA21481@flint.arm.linux.org.uk> <BANLkTimo18w5yuE4jtATPvbgENCL04LMpA@mail.gmail.com> <BANLkTimupUqpLDdDvMRjB+Js0xW59MTOQA@mail.gmail.com> <20110707093928.GA15325@flint.arm.linux.org.uk> <CA+gQ4tczHA2NGyLaVFjDs6CQjeQZbzNCCBU0zX4HVgaF4VFEFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+gQ4tczHA2NGyLaVFjDs6CQjeQZbzNCCBU0zX4HVgaF4VFEFQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 12:38:38PM +0800, Qin Dehua wrote:
> After doing the above changes, the kernel just report  BUG_ON(dir ==
> DMA_BIDIRECTIONAL):

That's really unfortunate.

The only other thing I can think which may help is to enable all the
raid5, async_tx and dmaengine debug code.  And I hope you have
DMA_API_DEBUG enabled in your .config ?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

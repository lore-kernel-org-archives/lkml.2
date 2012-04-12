Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab2DLXsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:48:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56319 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2DLXsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:48:45 -0400
Date: Fri, 13 Apr 2012 00:48:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120412234827.GG24211@n2100.arm.linux.org.uk>
References: <1331520476.4657.79.camel@vkoul-udesk3> <Pine.LNX.4.64.1203161029490.13465@axis700.grange> <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com> <Pine.LNX.4.64.1203161128120.13465@axis700.grange> <CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com> <Pine.LNX.4.64.1203161522570.13465@axis700.grange> <CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com> <20120330103828.GC22981@n2100.arm.linux.org.uk> <CACRpkdbjNqsWvv_0roFLGm_uzVFCOfeaek65=bxiUhU3XQXwKA@mail.gmail.com> <Pine.LNX.4.64.1204122325580.15801@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1204122325580.15801@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 11:33:28PM +0200, Guennadi Liakhovetski wrote:
> Now, how do we proceed from here? Do I understand it right, that Russell 
> would like to implement his ideas? Any idea when this is likely to happen? 

Well, I'm messing around with OMAP at the moment, converting its DMA
support to be DMA engine based.  As I think I've already said, I've
not taken _that_ much interest in dealing with how channels actually
get allocated there (though I do have something which works for the
time being so I can run and test this stuff.)

Note that the sa11x0 DMA engine driver uses strings to match channels,
and the strings are essentially identifiers for DMA request signals,
and this avoids either passing around DMA request numbers or having
them in some central header file.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0CVH6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:58:09 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:57803 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0CVH6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:58:07 -0400
Date: Mon, 22 Mar 2010 08:57:39 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PXA3xx internal SRAM
Message-ID: <20100322075739.GI30801@buzzloop.caiaq.de>
References: <20100321124739.GG30801@buzzloop.caiaq.de>
 <771cded01003211747n29be55a3p7608578ff1744f51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771cded01003211747n29be55a3p7608578ff1744f51@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 08:47:22PM -0400, Haojian Zhuang wrote:
> On Sun, Mar 21, 2010 at 8:47 AM, Daniel Mack <daniel@caiaq.de> wrote:
> > The pxa3xx series features a comparatively big and fast internal SRAM of
> > 256KB which is currently unused by the Linux kernel except for a 4-byte
> > return vector from suspend.
> >
> > I wonder what this could be used for. Is there any kind of cache that
> > would be worth putting there to speed up things for example?
> > And could the uncompressor probably benfit from that?
> >
> > Daniel
> 
> The size of internal SRAM isn't always 256KB. It could be 128KB, 256KB
> or 702KB. In marvell BSP, there's a memory management driver (aka IMM)
> to handle internal SRAM. So driver or user application could make use
> of it. And one part of internal SRAM is reserved for low power idle
> mode. But both of these two features aren't pushed into community yet.

Ok. I was more thinking about any kernel specific kind of cache that has
a fix size of 128kb or 256kb and which is consulted regularily. But I
don't know which kind of cache that could be.

As that's not neccessarily ARM-related, I copied LKML. Maybe anyone has
an idea.

Thanks,
Daniel


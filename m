Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0GNTeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:34:08 -0400
Received: from 8bytes.org ([88.198.83.132]:36383 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab0GNTeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:34:06 -0400
Date: Wed, 14 Jul 2010 21:34:03 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: Hari Kanigeri <hari.kanigeri@gmail.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
Message-ID: <20100714193403.GC23755@8bytes.org>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <20100701180241.GA3594@basil.fritz.box> <AANLkTinABCSdN6hnXVOvVZ12f1QBMR_UAi62qW8GmlkL@mail.gmail.com> <4C2D908E.9030309@codeaurora.org> <20100710143635.GA10080@8bytes.org> <4C3BF7C1.9040904@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3BF7C1.9040904@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 10:21:05PM -0700, Zach Pfeffer wrote:
> Joerg Roedel wrote:

> > The DMA-API already does this with the help of IOMMUs if they are
> > present. What is the benefit of your approach over that?
> 
> The grist to the DMA-API mill is the opaque scatterlist. Each
> scatterlist element brings together a physical address and a bus
> address that may be different. The set of scatterlist elements
> constitute both the set of physical buffers and the mappings to those
> buffers. My approach separates these two things into a struct physmem
> which contains the set of physical buffers and a struct reservation
> which contains the set of bus addresses (or device addresses). Each
> element in the struct physmem may be of various lengths (without
> resorting to chaining). A map call maps the one set to the other.

Okay, thats a different concept, where is the benefit?

	Joerg


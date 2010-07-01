Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0GAVAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:00:14 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:38021 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063Ab0GAVAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:00:00 -0400
Date: Thu, 1 Jul 2010 14:59:59 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Zach Pfeffer <zpfeffer@codeaurora.org>, mel@csn.ul.ie, andi@firstfloor.org,
       dwalker@codeaurora.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
In-Reply-To: <20100701101746.3810cc3b.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.2.00.1007011450130.13691@utopia.booyaka.com>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

On Thu, 1 Jul 2010, Randy Dunlap wrote:

> > + * @start_addr	The starting address of the VCM region.
> > + * @len 	The len of the VCM region. This must be at least
> > + *		vcm_min() bytes.
> 
> and missing lots of struct members here.
> If some of them are private, you can use:
> 
> 	/* private: */
> ...
> 	/* public: */
> comments in the struct below and then don't add the private ones to the
> kernel-doc notation above.

To avoid wasting space in structures, it makes sense to place fields 
smaller than the alignment width together in the structure definition.  
If one were to do this and follow your proposal, some structures may need 
multiple "private" and "public" comments, which seems undesirable.  The 
alternative, wasting memory, also seems undesirable.  Perhaps you might 
have a proposal for a way to resolve this?


- Paul

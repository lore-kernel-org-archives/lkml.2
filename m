Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab1DHWDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:03:23 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:24371 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab1DHWDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:03:22 -0400
Date: Fri, 8 Apr 2011 17:03:21 -0500
From: brace@beardog.cce.hp.com
To: linux-kernel@vger.kernel.org
Cc: brace@beardog.cce.hp.com, scameron@beardog.cce.hp.com
Subject: How to create a kernel virtual mapping for physical addresses.
Message-ID: <20110408220321.GA777@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given a physical address and a length (which may span contiguous pages), how
does one go about creating a virtual mapping for that address? That address may
be in high memory (above 4GB) in a 32bit system.

ioremap() wants a 32bit physical address on 32bit systems. kmap() and
kmap_atomic() wants a struct page which I am not sure how to get from a physical
address.

If there already is a kernel mapping, then using the existing kernel mapping
would be fine if I could figure out how to get it, but if there is not one,
then I need to make one.

I think setting the DMA mask to 32bit would mean that I do not have to deal
with highmem addresses in my particular case, but I still do not know how to
get a virtual address from a physical.

Any suggestions?

Don

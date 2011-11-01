Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1KAKck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 06:32:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57096 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1KAKcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 06:32:39 -0400
MIME-Version: 1.0
Date: Tue, 1 Nov 2011 19:32:38 +0900
Message-ID: <CANudz+unARaENw50p2iL_Ur1YQj0f=9Ndev0OyZ=790xDjbTCw@mail.gmail.com>
Subject: some questions about block and scatterlist
From: loody <miloody@gmail.com>
To: kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all:
My questions are below:
1. Are all struct page 32-bit aligned?
If so, where is this part of code for handleing struct page be 32-bits aligned?
2. if the page of scatterlist is located at high mem, how does
dma_map_sg mapping the virtual address?
3. in blk_rq_map_sg, it seems we only copy bvec->bv_page to sg->page_link
   why don't we add dma_address in bvec and send the bio directly to
the lower level driver?
4. if I plug a USB HD with 3 partitions, will there be 3 request_queues?


-- 
Regards,

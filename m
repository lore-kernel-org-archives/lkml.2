Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936874Ab0COVaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:30:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36669 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S936836Ab0COVaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:30:20 -0400
Date: Mon, 15 Mar 2010 17:30:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: dma_sync_sg_for_cpu applied to a single scatterlist element
Message-ID: <Pine.LNX.4.44L0.1003151721190.1332-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is addressed to James Bottomley as he is the author of
Documentation/DMA-API.txt, but anyone else who can contribute is
invited to do so.

Suppose a scatter-gather transfer with multiple scatterlist elements
has been mapped via dma_map_sg().  Is it then valid to call 
dma_sync_sg_for_cpu() with the "sg" argument pointing to one of the 
mapped scatterlist elements (not necessarily the first one) and the 
"nelems" argument set to 1?

Thanks,

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0IGPX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:23:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49779 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab0IGPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GV3OyDdeSJQGy1qt85Rq69O3eTBk3fSVpYgSzQqHjeGrv3NPopfebs9c6ttOUPhedL
         B0uj37Wdcr4F3wMGP6aPYFr4PkO8vwi9LtKUWTCRBMSTrEiRrMoCBdqRCBLWARzYHcHf
         XM4y8G5QvKDHNL/S2ImrJT8BRja+2XGdGBon8=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND/PATCH 0/6] USB: musb-gadget: bug fix 
Date: Tue,  7 Sep 2010 23:23:28 +0800
Message-Id: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes two kinds of musb-gadget bug:

	-fix kernel panic if using out ep with FIFO_TXRX style

	-make double buffer mode usable, fix infinate hangs and buffer
	corrupt bug when using double buffer mode to do data transfer;
	now we can use musb double buffer reliably, so bootst performance
	about 30% compared with single buffer mode.
	
		[RESEND/PATCH 1/6] USB: musb-gadget: fix kernel panic if using out ep with FIFO_TXRX style(v1)
		[RESEND/PATCH 2/6] USB: musb-gadget: fix bulk IN infinite hangs in double buffer case
		[RESEND/PATCH 3/6] USB: musb-gadget: enable autoclear for OUT transfer in both DMA 0 and DMA 1
		[RESEND/PATCH 4/6] USB: musb-gadget: fix DMA length for OUT transfer
		[RESEND/PATCH 5/6] USB: musb-gadget: complete request only if data is transfered over
		[RESEND/PATCH 6/6] USB: musb-gadget: fix dma length in txstate

thanks,
Lei Ming


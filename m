Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2BMPFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:05:33 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43726 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2BMPFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:05:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Mon, 13 Feb 2012 16:05:26 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: linux-next: build failure after merge of the dma-mapping tree
In-reply-to: <20120213164000.da84dfec7723af3a9eb3e13f@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <00dc01ccea60$ead06e30$c0714a90$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczqEfYI6SwPAAYPSPyU+w22zD3z3QAKgRxw
References: <20120213164000.da84dfec7723af3a9eb3e13f@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Monday, February 13, 2012 6:40 AM Stephen Rothwell wrote:
 
> After merging the dma-mapping tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:

(snipped)

I'm sorry for the problems. I've updated patches to fix these issues, as 
well as similar problems with MIPS and Hexagon architecture.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center




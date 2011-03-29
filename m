Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1C2XgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:36:05 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49715 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751975Ab1C2XgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:36:04 -0400
Message-Id: <20110329233602.272459647@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Mar 2011 18:36:02 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mike Habeck <habeck@sgi.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] pci: Speed up processing of IOMMU related functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    During testing of a large customer UV configuration with a lot of
    I/O devices, certain IOMMU functions were either consuming too much
    time or not functioning correctly.

    This patchset addresses those problems.

Signed-off-by: Mike Travis <travis@sgi.com>

-- 

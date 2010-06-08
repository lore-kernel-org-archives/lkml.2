Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0FHPvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:51:50 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48403 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab0FHPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:51:49 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: kvm <kvm@vger.kernel.org>
Cc: Avi Kivity <avi@redhat.com>, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Tue, 08 Jun 2010 21:21:40 +0530
Message-Id: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
Subject: [RFC/T/D][PATCH 0/2] KVM page cache optimization (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2 of the page cache control patches for
KVM. This series has two patches, the first controls
the amount of unmapped page cache usage via a boot
parameter and sysctl. The second patch controls page
and slab cache via the balloon driver. Both the patches
make heavy use of the zone_reclaim() functionality
already present in the kernel.

page-cache-control
balloon-page-cache

-- 
	Three Cheers,
	Balbir

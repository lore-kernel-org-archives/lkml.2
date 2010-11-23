Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab0KWIpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:45:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:19052 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab0KWIpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:45:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208";a="680147325"
Date: Tue, 23 Nov 2010 16:43:09 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, arjan@linux.intel.com,
        hang.yuan@intel.com
Subject: [PATCH v1 0/4]mmc: enable eMMC4.41 new feature background
	operations and HPI
Message-ID: <20101123084309.GA17754@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	These patches were enabled eMMC4.41 standard new feature: background
	operations and HPI.

	Since these two features are opertional, driver only enable for those
	eMMC card which supports them.

	HPI can interrupt both background operations and low priority foreground
	operations. In these patches, only implemented using HPI to interrupt
	background operations.

	patch1: enable background operations feature for supported eMMC card.
	patch2: let eMMC card do background operations when user reqeust queue
	is idle. In this patch, also considered when driver added runtime power
	management.
	patch3: enable HPI feature for supported eMMC card.
	patch4: use HPI to interrupt background operations if there is user
	request(foreground operations).

Thanks
Chuanxiao

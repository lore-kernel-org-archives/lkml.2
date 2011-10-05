Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934818Ab1JEPPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:15:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:59710 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856Ab1JEPPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:15:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,491,1312182000"; 
   d="scan'208";a="59069519"
Date: Wed, 5 Oct 2011 23:15:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: new location for writeback-for-next
Message-ID: <20111005151546.GA5472@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Since the kernel.org git tree is still not accessible, would you pull
from this tree instead of the old writeback.git?

        git://github.com/fengguang/linux.git  writeback-for-next

Thanks,
Fengguang

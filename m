Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0HZCNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 22:13:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:14545 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab0HZCNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 22:13:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,271,1280732400"; 
   d="scan'208";a="831816774"
Date: Thu, 26 Aug 2010 10:13:43 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "bchociej@gmail.com" <bchociej@gmail.com>
Cc: "chris.mason@oracle.com" <chris.mason@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmm@us.ibm.com" <cmm@us.ibm.com>,
        "bcchocie@us.ibm.com" <bcchocie@us.ibm.com>,
        "mrlupfer@us.ibm.com" <mrlupfer@us.ibm.com>,
        "crscott@us.ibm.com" <crscott@us.ibm.com>,
        "mlupfer@gmail.com" <mlupfer@gmail.com>,
        "conscott@vt.edu" <conscott@vt.edu>
Subject: Re: [RFC v2 PATCH 0/6] Btrfs: Add hot data relocation functionality
Message-ID: <20100826021343.GA452@sli10-conroe.sh.intel.com>
References: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 06:22:00AM +0800, bchociej@gmail.com wrote:
> 
> - Hooks in existing Btrfs functions to track data access frequency
>   (btrfs_direct_IO, btrfs_readpages, and extent_write_cache_pages)
> 
> - New rbtrees for tracking access frequency of inodes and sub-file
>   ranges (hotdata_map.c)
> 
> - A hash list for indexing data by its temperature (hotdata_hash.c)
> 
> - A debugfs interface for dumping data from the rbtrees (debugfs.c)
> 
> - A background kthread for relocating data to faster media based on
>   temperature
Hi,
I'm wondering if the temperature info can be exported to userspace, and
let a daemon to do the relocation (by ioctl). A userspace daemon is more
flexible.

Thanks,
Shaohua

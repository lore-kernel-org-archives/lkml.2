Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1DNQap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:30:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:44537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab1DNQao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:30:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,212,1301900400"; 
   d="scan'208";a="419255918"
Date: Thu, 14 Apr 2011 09:30:23 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        Matthew Wilcox <willy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>, Tony Luck <tony.luck@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH] vfs: make vfs_mount lock scale for file systems without
 mount point
Message-ID: <20110414163023.GA16450@tassilo.jf.intel.com>
References: <1302732011.2592.102.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302732011.2592.102.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The attached patch marks file systems without mount point as long term.
> The contentions of vfs_mount lock is now completely eliminated.  

Patch looks good to me (except for the >80chars in the comment) 

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

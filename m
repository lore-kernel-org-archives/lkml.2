Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab1ESVRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:17:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:57649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab1ESVRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:17:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="4855575"
Date: Fri, 20 May 2011 05:17:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/17] writeback: introduce .tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110519211729.GA19304@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140030.759385136@intel.com>
 <20110512224013.GH19446@dastard>
 <20110513025607.GA8016@localhost>
 <20110515234306.GO19446@dastard>
 <20110516053946.GA10776@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516053946.GA10776@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> shall we rename .tagged_sync to .tagged_write?

FYI, I finally renamed the flag to .tagged_writepages which most
precisely describes what it's doing.

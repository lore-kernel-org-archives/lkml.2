Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab2IZMvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:51:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:23706 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab2IZMvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:51:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,490,1344236400"; 
   d="scan'208";a="226771620"
Date: Wed, 26 Sep 2012 20:51:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yan Hong <clouds.yan@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] fs/fs-writeback.c: remove unneccesary parameter of
 __writeback_single_inode()
Message-ID: <20120926125142.GA7289@localhost>
References: <1348659510-9059-1-git-send-email-clouds.yan@gmail.com>
 <1348659510-9059-3-git-send-email-clouds.yan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348659510-9059-3-git-send-email-clouds.yan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 07:38:30PM +0800, Yan Hong wrote:
> The parameter 'wb' is never used in this function.

Good spot!

Acked-by: Fengguang Wu <fengguang.wu@intel.com>

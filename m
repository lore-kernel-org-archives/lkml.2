Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab1LRLmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 06:42:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:14167 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab1LRLmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 06:42:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="86947546"
Date: Sun, 18 Dec 2011 19:32:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Message-ID: <20111218113237.GA1359@localhost>
References: <20111218055359.GA17182@localhost>
 <20111218063054.GA4979@localhost>
 <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yongqiang,

Thanks for the quick fix!

On Sun, Dec 18, 2011 at 03:17:18PM +0800, Yongqiang Yang wrote:
> Hi Fengguang,
> 
> Could you try the patch [ext4: do not reference pa_inode from group_pa]?

It works! You can add my tested-by and CC stable.

Thanks,
Fengguang

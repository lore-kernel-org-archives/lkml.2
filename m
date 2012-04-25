Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab2DYN6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:58:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:23190 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab2DYN6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158189829"
Date: Wed, 25 Apr 2012 21:57:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs: remove 8 bytes of padding from struct
 writeback_control on 64 bit builds
Message-ID: <20120425135734.GA4995@localhost>
References: <1335361985.1885.16.camel@castor.rsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335361985.1885.16.camel@castor.rsk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 02:53:05PM +0100, Richard Kennedy wrote:
> Reorder structure writeback_control to remove 8 bytes of padding on 64
> bit builds, this shrinks its size from 48 to 40 bytes.
> 
> This structure is always on the stack and uses C99 named initialisation,
> so should be safe and have a small impact on stack usage.
>     
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> --
> 
> patch against v3.4-rc4
> compiled and tested on x86_64
> 
> I've been running my desktop with this patch applied for several days
> and have not seen any problems.
> regards
> Richard

Applied, thanks!

Fengguang

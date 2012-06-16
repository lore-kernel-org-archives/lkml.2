Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2FPNVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:21:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:19067 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723Ab2FPNVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:21:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166436019"
Date: Sat, 16 Jun 2012 21:21:24 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] printk: return -EINVAL if the message len is bigger
 than the buf size
Message-ID: <20120616132124.GB12272@localhost>
References: <1339821655-14059-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1339821655-14059-2-git-send-email-yuanhan.liu@linux.intel.com>
 <CAPXgP130QzSzPObbDedqMLc2Fw6CgzJNW56ccQeRPmZPp27JOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP130QzSzPObbDedqMLc2Fw6CgzJNW56ccQeRPmZPp27JOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 02:50:53PM +0200, Kay Sievers wrote:
> On Sat, Jun 16, 2012 at 6:40 AM, Yuanhan Liu
> <yuanhan.liu@linux.intel.com> wrote:
> > Just like what devkmsg_read() does, return -EINVAL if the message len is
> > bigger than the buf size, or it will trigger a segfault error.
> 
> Looks good to me.

Me too :)

Thanks,
Fengguang

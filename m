Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965607Ab2EOPs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:48:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:62308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965396Ab2EOPsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:48:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144279862"
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1205151037500.1796-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1205151037500.1796-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 15 May 2012 23:49:11 +0800
Message-ID: <1337096951.3515.11.camel@chief-river-32>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 10:39 -0400, Alan Stern wrote:
> On Tue, 15 May 2012, Lin Ming wrote:
> 
> > Add an idle timer that is set to some suitable timeout and would be
> > added when the queue first goes empty. If nothing has happened during
> > the timeout interval, then the queue is suspended.
> 
> You don't need to create an idle timer for runtime PM support; the 
> runtime PM framework already has such a timer.  Read 
> Documentation/power/runtime_pm.txt, especially the parts describing 
> pm_runtime_autosuspend() and related functions.

OK, will use pm_runtime_autosuspend.

> 
> Alan Stern
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2EROwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:52:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:65324 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab2EROwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:52:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101644461"
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 18 May 2012 22:53:26 +0800
Message-ID: <1337352806.4071.2.camel@chief-river-32>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 14:29 -0400, Alan Stern wrote:

[ ... ]

> 
> I may have left some parts out from this brief description.  Hopefully 
> you'll be able to figure out the general idea and get it to work.

Thanks for the detail idea.

Let me look at it closely first.

> 
> Alan Stern
> 



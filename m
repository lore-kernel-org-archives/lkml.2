Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1KKCdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 21:33:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:16145 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab1KKCds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 21:33:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,491,1315206000"; 
   d="scan'208";a="35664650"
Subject: Re: [PATCH v2 0/4] ata port runtime power management support
From: Lin Ming <ming.m.lin@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20111110153036.GC27258@google.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
	 <20111110153036.GC27258@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 10:33:44 +0800
Message-ID: <1320978824.32515.12.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 23:30 +0800, Tejun Heo wrote:
> 
> Yeah, I really like this approach.  Nicely done.  I *think* the
> hierarchy change should be okay but cc'ing Kay just in case.
> 
>  Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

> 
> Thanks.
> 



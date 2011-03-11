Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1CKABR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:01:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:49192 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab1CKABO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:01:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,299,1297065600"; 
   d="scan'208";a="400913473"
Subject: isci for 2.6.39?
From: Dan Williams <dan.j.williams@intel.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Ed Nadolski <edmund.nadolski@intel.com>,
        Ed Ciechanowski <ed.ciechanowski@intel.com>,
        Jacek Danecki <jacek.danecki@intel.com>,
        Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 16:02:37 -0800
Message-ID: <1299801757.8641.21.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

Given the impending opening of the 2.6.39 merge window I would like to
discuss the options for merging the isci driver.  Review has been
intermittent which is understandable given the size and flux of the
codebase.  It has received a good amount of cleanups, but additional
review issues and cleanups are still all too easy to spot.  I know you
have expressed reservations about taking scsi drivers through -staging
in the past [1], so I would like to propose an alternative.  Merge the
driver into scsi-misc but with a -staging style TODO file that tracks
the review issues.  If the TODO file is not addressed by the 2.6.40
window the driver would be moved to -staging.  This has the benefit of
keeping the driver under your purview and expected location, but still
have the imminent prospect of being de-staged to ensure the community's
concerns are ultimately addressed.  We fully intend to maintain the
current momentum on the driver cleanup effort and be ready in advance of
2.6.40.

As a side note I'm still looking for a disposition for:
"libsas: flush initial device discovery before completing ->scan_finished()" [2]
"libsas: fix/amend device gone notification in sas_deform_port()" [3]

Both have since been: Acked-by: Jack Wang <jack_wang@usish.com>

Thanks,
Dan for the isci driver team

[1]: http://marc.info/?l=linux-scsi&m=125536150519905&w=2
[2]: http://marc.info/?l=linux-scsi&m=129791077719331&w=2
[3]: http://marc.info/?l=linux-scsi&m=129791105419577&w=2



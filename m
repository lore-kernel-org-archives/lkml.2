Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1CAVKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:10:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:46394 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab1CAVKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:10:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,249,1297065600"; 
   d="scan'208";a="892721297"
From: "Allyn, Mark A" <mark.a.allyn@intel.com>
To: Greg KH <greg@kroah.com>,
        "Mangalampalli, Jayant" <jayant.mangalampalli@intel.com>,
        "Gokulrangan, Venkat R" <venkat.r.gokulrangan@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Date: Tue, 1 Mar 2011 14:10:09 -0700
Subject: RE: RFC: [PATCH 0/5] staging: sep: Enable kernel crypto
Thread-Topic: RFC: [PATCH 0/5] staging: sep: Enable kernel crypto
Thread-Index: AcvXjUhPArmIaZ+pSFGYLYs50T7LdwAx5MKw
Message-ID: <8A0E4C92AE2D6D40AF99653191DA3231614A0A654E@rrsmsx501.amr.corp.intel.com>
References: <1298869824-4246-1-git-send-email-mark.a.allyn@intel.com>
 <20110228212018.GE8851@kroah.com>
In-Reply-To: <20110228212018.GE8851@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg writes:

Why?  What does this mean to me?  To users?  You need to sell this new
feature to me a LOT before I will take it as I really want and need to
see this driver fixed up first before you can add new features to it.

thanks,

greg k-h


=================

Greg:

I agree; I will work on getting the current core driver out of staging prior to making the kernel crypto changes.

What are the major issues with the core driver? I know about the current items in the TODO list having to do with the unused ioctl calls and structures.

What other issues are there?

Thanks

Mark Allyn

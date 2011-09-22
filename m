Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1IVNnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:43:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:3314 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab1IVNnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,423,1312182000"; 
   d="scan'208";a="53375905"
From: "Weil, Oren jer" <oren.jer.weil@intel.com>
To: "gregkh@suse.de" <gregkh@suse.de>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "Noam, Amir" <amir.noam@intel.com>
Date: Thu, 22 Sep 2011 16:43:45 +0300
Subject: MEI Driver - Moving to Main tree
Thread-Topic: MEI Driver - Moving to Main tree
Thread-Index: Acx5LaXidV+gkmmESV+cQkgQX8yaBA==
Message-ID: <F28B59AD52D84B479DCA4698244753350671AD513A@hasmsx503.ger.corp.intel.com>
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

Hello Greg.

Yesterday I have submitted the last patch of our effort to cleanup, order and stabilize the MEI driver.
As we see it the driver is stable and ready to move to main tree.
The last task that was left in the TODO (splitting of the driver timer) is task that is not related stability of the driver, 
it is part of preparing the driver infrastructure to better support newer HW in the future.

I would like to move the driver to main tree, what do you think?


---
Oren Weil - Intel Corporation.
http://www.intel.com




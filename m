Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2FMVJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:09:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:31544 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2FMVJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111836291"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: misc: mei: fixes for 3.5
Thread-Topic: misc: mei: fixes for 3.5
Thread-Index: AQHNSaRfBG8z7OzU9kWYSomehzL8KJb4vB/A
Date: Wed, 13 Jun 2012 21:09:14 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B12A780@HASMSX103.ger.corp.intel.com>
References: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
 <20120613203729.GA11326@kroah.com>
In-Reply-To: <20120613203729.GA11326@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Hi Greg,
> > please consider this batch for queuing into 3.5 1. patch 2/4 bug in
> > probe: visible only after merging with the trunk 2. patch 3/4 fixes
> > kernel oops that was revealed when probe failed 3. patch 4/4 is
> > regression fix and should be merged also to stable 3.4 4. patch 1/4 is
> > a minor documentation fix
> 
> Grammer fixes are not ok for 3.5 at this point in time, sorry.  I'll queue up the
> other 3 though.

Thanks reasonable. 

Please consider also  this two:

This one is one more fix connected to the same issue as the 3 patches. (From Samuel Oritz) 
http://marc.info/?l=linux-kernel&m=133940653731271&w=2

This one is just adding a flag to WATCHDOG devices that was only possible after merging the watchdog tree into 3.5-rc1. 
This one is not must so I leave it for you to decide. 
http://marc.info/?l=linux-kernel&m=133940653831272&w=2


Thanks
Tomas

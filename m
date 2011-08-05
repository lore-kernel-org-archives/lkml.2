Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1HECAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 22:00:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:11041 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab1HECAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 22:00:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,320,1309762800"; 
   d="scan'208";a="38066864"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Nguyen, Tom L" <tom.l.nguyen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Date: Fri, 5 Aug 2011 09:59:39 +0800
Subject: RE: [rfc] suppress excessive AER output
Thread-Topic: [rfc] suppress excessive AER output
Thread-Index: AcxTEgYii493c2yYS8uw+eTdu0aA5AAABk3g
Message-ID: <33AB447FBD802F4E932063B962385B3512D9615B4D@shsmsx501.ccr.corp.intel.com>
References: <20110803223407.GA20646@redhat.com>
 <33AB447FBD802F4E932063B962385B3512D9615780@shsmsx501.ccr.corp.intel.com>
 <20110805015008.GA19434@redhat.com>
In-Reply-To: <20110805015008.GA19434@redhat.com>
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

Dave,

My idea is application has opportunity to reset it. Consider the critical mission environment, admin could hot-unplug any failed devices without rebooting system. Then, admin doesn't want to lose AER monitoring.

With the module parameter, admin could change it under /sys/module/aer_drv/parameters.

Yanmin

-----Original Message-----
From: Dave Jones [mailto:davej@redhat.com] 
Sent: Friday, August 05, 2011 9:50 AM
To: Zhang, Yanmin
Cc: Linux Kernel; Nguyen, Tom L; Huang, Ying
Subject: Re: [rfc] suppress excessive AER output

On Thu, Aug 04, 2011 at 01:54:19PM +0800, Zhang, Yanmin wrote:
 > Dave,
 > 
 > How about adding a new module parameter aer_printk_limit, so user space could reset it any time?

Sure. Though for the built-in case, how would that work ?

	Dave


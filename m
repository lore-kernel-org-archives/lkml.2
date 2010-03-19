Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab0CSWxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:53:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:36052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0CSWxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:53:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,276,1267430400"; 
   d="scan'208";a="782404759"
From: "Othman, Ossama" <ossama.othman@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 19 Mar 2010 15:53:07 -0700
Subject: RE: [PATCH] Intel Restricted Access Region Handler
Thread-Topic: [PATCH] Intel Restricted Access Region Handler
Thread-Index: AcrHq6vFh8RyDnhTQGSvwVvyrFYAkwAAGXdg
Message-ID: <A5FE05C4C76E4C4CAB15D9962B96FC950C9A7A6431@orsmsx510.amr.corp.intel.com>
References: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
	<20100314181040.GB28359@suse.de>
	<A5FE05C4C76E4C4CAB15D9962B96FC950C9A6D184E@orsmsx510.amr.corp.intel.com>
	<20100315234508.GB4008@suse.de>
 <20100319143222.72aee474.akpm@linux-foundation.org>
In-Reply-To: <20100319143222.72aee474.akpm@linux-foundation.org>
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

Andrew, Greg,

> Regarding the code itself: it appears to implement a userspace
> interface via some /dev node.  But there is no description of this
> interface at all in the changelog and there is no documentation
> provided.  But the userspace-facing interface is the most important
> part of the entire feature, because it is something we cannot ever
> change.  It should be exhaustively described right up-front in the
> changelog so that reviewers can easily and fully understand the
> proposed API.

Would a README file of some sort be suitable to describe the driver interface or should I just embed additional documentation in the driver's interface header?

Thanks,
-Ossama

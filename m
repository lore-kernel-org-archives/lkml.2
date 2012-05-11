Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946346Ab2EKWf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:35:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:55786 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946205Ab2EKWfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:35:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165164928"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH v.23-2] RAS: use tracepoint to handle hw issues
Thread-Topic: [PATCH v.23-2] RAS: use tracepoint to handle hw issues
Thread-Index: AQHNL4YeaA7E6BnMIESUIXda6cSFE5bFRzGAgAABCgCAAFmcgP//iw7Q
Date: Fri, 11 May 2012 22:35:23 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192ED6F5@ORSMSX104.amr.corp.intel.com>
References: <1336683628-12954-1-git-send-email-mchehab@redhat.com>
 <1336748054-21325-1-git-send-email-mchehab@redhat.com>
 <20120511170647.GA17299@aftab.osrc.amd.com> <4FAD4806.2010507@redhat.com>
 <20120511223113.GA18908@aftab.osrc.amd.com>
In-Reply-To: <20120511223113.GA18908@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Subject: RAS: Add a tracepoint for reporting memory controller errors

s/errors/events/ ... since Mauro has pointed out that some events like:
"spare copy initiated" and "spare copy completed" may be reported using
this tracepoint ... and they are not errors

-Tony

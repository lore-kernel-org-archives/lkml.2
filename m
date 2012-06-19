Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2FSSzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:55:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:11492 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab2FSSzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:55:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="155602881"
From: "Luck, Tony" <tony.luck@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
Thread-Topic: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
Thread-Index: AQHNTiGCR/IHcl/GWkC68iIMFFb8LJcB/N4g
Date: Tue, 19 Jun 2012 18:55:05 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19321FBF@ORSMSX104.amr.corp.intel.com>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is only built tested on the relevant archs.

Built and run on ia64 ... seems to work (but I don't have any
tests that really show the difference between having this turned
on/off :-(  )

-Tony

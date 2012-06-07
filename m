Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2FGQW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:22:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:26866 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2FGQW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:22:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152994969"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [patch 0/5] x86: mce: Bugfixes, cleanups and a new CMCI poll
 version
Thread-Topic: [patch 0/5] x86: mce: Bugfixes, cleanups and a new CMCI poll
 version
Thread-Index: AQHNRC7WkhFIdxHVtkmJOvUeOBJl15bvF+KAgAA5/4D//7iK4A==
Date: Thu, 7 Jun 2012 16:22:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19304893@ORSMSX104.amr.corp.intel.com>
References: <20120606214941.104735929@linutronix.de>
 <4FD07D8F.5020303@linux.intel.com>
 <20120607133549.GH11153@aftab.osrc.amd.com>
In-Reply-To: <20120607133549.GH11153@aftab.osrc.amd.com>
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

> Stupid question: do you even want to allow offlining of CPUs while the
> storm is raging? IOW, wouldn't it be better to disallow hotplug when the
> storm happens so that all online CPUs, which is all CPUs on the system,
> can work out the storm conditions faster so that the system gets back to
> normal faster...

What if a processor is the source of the storm (we can get CMCI from
corrected errors in the cache)? Then our action to abate the storm would
be to take the cpu offline.

-Tony

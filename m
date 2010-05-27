Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935108Ab0E0Sko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:40:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:59602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759477Ab0E0Skn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,312,1272870000"; 
   d="scan'208";a="521818420"
From: "Luck, Tony" <tony.luck@intel.com>
To: Len Brown <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 27 May 2010 11:40:41 -0700
Subject: RE: [PATCH-v2 3/8] cpuidle: make cpuidle_curr_driver static
Thread-Topic: [PATCH-v2 3/8] cpuidle: make cpuidle_curr_driver static
Thread-Index: Acr9XVqYFdWC6z2NRK++baskl94vdQAbLGCg
Message-ID: <987664A83D2D224EAE907B061CE93D5301135014D2@orsmsx505.amr.corp.intel.com>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <db2b1d371847edfdbba21f323b4fd4a480c8c5aa.1274926772.git.len.brown@intel.com>
 <alpine.LFD.2.00.1005270126000.4039@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005270126000.4039@localhost.localdomain>
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

+static inline cpuidle_driver *cpuidle_get_driver(void) {return NULL;}

Close, but no cigar yet. You missed a "struct" keyword on this line.
Add that, and it builds and boots for me.

-Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab0ENV3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:29:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:10403 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab0ENV3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:29:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,233,1272870000"; 
   d="scan'208";a="277315985"
From: "Luck, Tony" <tony.luck@intel.com>
To: "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>
CC: "martin.schwidefsky@de.ibm.com" <martin.schwidefsky@de.ibm.com>,
       "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
       "jlan@sgi.com" <jlan@sgi.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Date: Fri, 14 May 2010 14:28:48 -0700
Subject: RE: [PATCH] Use microsecond granularity for taskstats accounting
Thread-Topic: [PATCH] Use microsecond granularity for taskstats accounting
Thread-Index: AcrzaItOlZif8S4xRfyEh5Mj9gpMQAAQwbSg
Message-ID: <987664A83D2D224EAE907B061CE93D53C6120ABB@orsmsx505.amr.corp.intel.com>
References: <1273843352.2615.61.camel@holzheu-laptop>
In-Reply-To: <1273843352.2615.61.camel@holzheu-laptop>
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

You delete the only users of cputime_to_msecs() ... should
you also delete the definition from asm-generic/cputime.h?
Same for the msecs_to_cputime() that had no users.

Is it worth adding the usecs_to_cputime() functions/macros.
Symmetry is nice (and matches what used to be there, but
unused code isn't very worthwhile.

-Tony

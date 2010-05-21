Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0EUH3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 03:29:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:8331 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab0EUH3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 03:29:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,277,1272870000"; 
   d="scan'208";a="569284232"
From: "Kleen, Andi" <andi.kleen@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       minskey guo <chaohong_guo@linux.intel.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "prarit@redhat.com" <prarit@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Guo, Chaohong" <chaohong.guo@intel.com>, Tejun Heo <tj@kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Date: Fri, 21 May 2010 08:29:09 +0100
Subject: RE: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
Thread-Topic: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
Thread-Index: Acr4XTPOpaZtSmemSemX4/836SgOBwAWgpJA
Message-ID: <F4DF93C7785E2549970341072BC32CD722717DBB@irsmsx503.ger.corp.intel.com>
References: <1274163442-7081-1-git-send-email-chaohong_guo@linux.intel.com>
 <20100520134359.fdfb397e.akpm@linux-foundation.org>
In-Reply-To: <20100520134359.fdfb397e.akpm@linux-foundation.org>
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

>
>How serious is this issue?  Just a warning?  Dead box?

It's pretty much a showstopper for memory hotadd with a new node.

-Andi


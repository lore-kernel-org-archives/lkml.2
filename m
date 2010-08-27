Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0H0U3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:29:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:35580 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0H0U3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:29:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,280,1280732400"; 
   d="scan'208";a="832586068"
From: "Luck, Tony" <tony.luck@intel.com>
To: Petr Tesarik <ptesarik@suse.cz>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hedi Berriche <hedi@sgi.com>
Date: Fri, 27 Aug 2010 13:29:41 -0700
Subject: RE: Serious problem with ticket spinlocks on ia64
Thread-Topic: Serious problem with ticket spinlocks on ia64
Thread-Index: ActF7PEv2I9vz36oSbC8JQLkGmsl5wAEsetAAAmmUxA=
Message-ID: <987664A83D2D224EAE907B061CE93D53015D91D3B7@orsmsx505.amr.corp.intel.com>
References: <201008271537.35709.ptesarik@suse.cz>
 <987664A83D2D224EAE907B061CE93D53015D91D029@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015D91D029@orsmsx505.amr.corp.intel.com>
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

> If this is a memory ordering problem (and that seems quite plausible)
> then a liberal sprinkling of "ia64_mf()" calls throughout the spinlock
> routines would probably make it go away.

I think I take this back ... if it were a memory ordering problem, then
it could show up any time - not just at wrap-around.

-Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0H0VMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:12:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:7511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0H0VMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,280,1280732400"; 
   d="scan'208";a="652006932"
From: "Luck, Tony" <tony.luck@intel.com>
To: Petr Tesarik <ptesarik@suse.cz>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hedi Berriche <hedi@sgi.com>
Date: Fri, 27 Aug 2010 14:11:55 -0700
Subject: RE: Serious problem with ticket spinlocks on ia64
Thread-Topic: Serious problem with ticket spinlocks on ia64
Thread-Index: ActGK0PzUhFgckTtQg2dPIrcwTwA8wAANvww
Message-ID: <987664A83D2D224EAE907B061CE93D53015D91D45F@orsmsx505.amr.corp.intel.com>
References: <201008271537.35709.ptesarik@suse.cz>
 <987664A83D2D224EAE907B061CE93D53015D91D029@orsmsx505.amr.corp.intel.com>
 <987664A83D2D224EAE907B061CE93D53015D91D3B7@orsmsx505.amr.corp.intel.com>
 <201008272303.34228.ptesarik@suse.cz>
In-Reply-To: <201008272303.34228.ptesarik@suse.cz>
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

> One more idea. The wrap-around case is the only one when the high word is 
> modified. This is in fact the only case when the fetchadd.acq competes with 
> the st2.rel about the actual contents of that location. I don't know if it 
> matters...

I pondered that for a while - but I have difficulty believing that
fetchadd looks at which bits changed and only writes back the bytes
that did.

-Tony

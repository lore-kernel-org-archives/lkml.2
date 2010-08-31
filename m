Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0HaXZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:25:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:41355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0HaXZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,301,1280732400"; 
   d="scan'208";a="833679167"
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        Joe Perches <joe@perches.com>, "mingo@elte.hu" <mingo@elte.hu>
Date: Tue, 31 Aug 2010 16:25:06 -0700
Subject: RE: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
Thread-Topic: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
Thread-Index: ActJYtNnDxi9K3zoRMKuTUylIsTc4gAAGaPw
Message-ID: <987664A83D2D224EAE907B061CE93D53015D9B2445@orsmsx505.amr.corp.intel.com>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	<1282837904.1875.64.camel@Joe-Laptop>
	<20100826161451.GB2367@linux.vnet.ibm.com>
	<1282839933.8133.11.camel@mulgrave.site>
	<20100826092923.4bdbea69.rdunlap@xenotime.net>
	<20100826093838.74ab9958@infradead.org>
	<1283275388.1377.216.camel@gandalf.stny.rr.com>
	<20100831230213.GG2421@linux.vnet.ibm.com>
 <1283296622.1377.765.camel@gandalf.stny.rr.com>
In-Reply-To: <1283296622.1377.765.camel@gandalf.stny.rr.com>
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

>Then, the list is maintained outside of mainline (in the subsystem git
>tree) and will automatically update mainline in the next merge window
>when the tree is pulled.

But this would mean that the version of the todo list in Linus' tree
is usually a release (3 months) out of date.  It would be a good idea
for a list maintained this way to include instructions on how to find
the current version, lest some unsuspecting person waste time working
on items that are already fixed and waiting for the next merge.

-Tony

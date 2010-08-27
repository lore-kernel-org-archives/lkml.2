Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab0H0Xzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:55:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:17910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0H0Xzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:55:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,281,1280732400"; 
   d="scan'208";a="652047176"
From: "Luck, Tony" <tony.luck@intel.com>
To: Petr Tesarik <ptesarik@suse.cz>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hedi Berriche <hedi@sgi.com>
Date: Fri, 27 Aug 2010 16:55:46 -0700
Subject: RE: Serious problem with ticket spinlocks on ia64
Thread-Topic: Serious problem with ticket spinlocks on ia64
Thread-Index: ActGNP8fGGVxQmxESVOm2Y7JfmO8pwACKhogAAFXoAA=
Message-ID: <987664A83D2D224EAE907B061CE93D53015D91D645@orsmsx505.amr.corp.intel.com>
References: <201008271537.35709.ptesarik@suse.cz>
 <201008272303.34228.ptesarik@suse.cz>
 <987664A83D2D224EAE907B061CE93D53015D91D45F@orsmsx505.amr.corp.intel.com>
 <201008280013.19941.ptesarik@suse.cz>
 <987664A83D2D224EAE907B061CE93D53015D91D604@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015D91D604@orsmsx505.amr.corp.intel.com>
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

> this fails so catastrophically

Interesting ... getting rid of some of the fancy asm bits
(replacing both the ld4.c.nc and the ld2.bias with simple
"serve = *p" and "tmp = *p") makes this run a lot better.

-Tony


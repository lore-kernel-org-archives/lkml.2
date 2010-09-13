Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0IMU5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:57:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:6906 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0IMU5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:57:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,360,1280732400"; 
   d="scan'208";a="656871934"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>
CC: "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eranian@google.com" <eranian@google.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "Metzger, Markus T" <markus.t.metzger@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>
Date: Mon, 13 Sep 2010 13:57:17 -0700
Subject: RE: [perfmon2] [PATCH] perf_events: improve DS/BTS/PEBS buffer
	allocation
Thread-Topic: [perfmon2] [PATCH] perf_events: improve DS/BTS/PEBS buffer
	allocation
Thread-Index: ActThYsHDRBiH3WsR76ssnDeUI0FVAAAEM5g
Message-ID: <987664A83D2D224EAE907B061CE93D53015DC52F43@orsmsx505.amr.corp.intel.com>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	<877hip4et0.fsf@basil.nowhere.org>	<1284407360.2275.431.camel@laptop>
 <20100913225137.042ff889@basil.nowhere.org>
In-Reply-To: <20100913225137.042ff889@basil.nowhere.org>
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

> I am not aware of any real technical issues, except that
> it needs to be done for both 32bit and 64bit.

Some good documentation on when you need vmalloc_sync_all(), and
why most places don't need it would help to avoid a surge of
patches spraying calls to it all over the kernel.

-Tony

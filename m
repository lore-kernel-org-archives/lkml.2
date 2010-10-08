Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab0JHSNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:13:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:10532 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693Ab0JHSNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:13:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,304,1283756400"; 
   d="scan'208";a="614765510"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Date: Fri, 8 Oct 2010 11:13:27 -0700
Subject: RE: [PATCH] Define _addr_lsb in siginfo_t for mips and ia64
Thread-Topic: [PATCH] Define _addr_lsb in siginfo_t for mips and ia64
Thread-Index: ActnEffI/jRkMHzGQSyGDt6A5CbwQgAAiEFQ
Message-ID: <987664A83D2D224EAE907B061CE93D530163EA9C09@orsmsx505.amr.corp.intel.com>
References: <1286560501-26843-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1286560501-26843-1-git-send-email-andi@firstfloor.org>
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

ia64 has HAVE_ARCH_COPY_SIGINFO_TO_USER - so it doesn't see
this build problem because the version of copy_siginfo_to_user()
in kernel/signal.c isn't the one we use. So I don't think that
we need this (unless someone has some plan to unify the
ARCH specific version).

-Tony


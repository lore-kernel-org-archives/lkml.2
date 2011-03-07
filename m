Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1CGV6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:58:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:53226 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275Ab1CGV6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:58:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,279,1297065600"; 
   d="scan'208";a="894760984"
From: "Luck, Tony" <tony.luck@intel.com>
To: Michel Lespinasse <walken@google.com>, Darren Hart <dvhltc@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: Matt Turner <mattst88@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 7 Mar 2011 13:58:30 -0800
Subject: RE: [PATCH] futex: cmpxchg_futex_value_locked API change
Thread-Topic: [PATCH] futex: cmpxchg_futex_value_locked API change
Thread-Index: AcvcbRiAx5Yf1S92QYyhestru/6I5QApXWcw
Message-ID: <987664A83D2D224EAE907B061CE93D53019DA69EFC@orsmsx505.amr.corp.intel.com>
References: <20110307021127.GB31188@google.com>
In-Reply-To: <20110307021127.GB31188@google.com>
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

Tried out the ia64 bits. They seem fine.

Acked-by: Tony Luck <tony.luck@intel.com>

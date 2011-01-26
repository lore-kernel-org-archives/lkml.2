Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1AZUGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:06:33 -0500
Received: from www.tglx.de ([62.245.132.106]:44517 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1AZUG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:29 -0500
Message-Id: <20110126195810.247325792@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 26 Jan 2011 20:05:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: [patch 0/6] rwsem: Cleanup duplicate code all over the place
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The archictecture specific rwsem implementations have a lot of
duplicated code. The following series cleans that up.

Thanks,

	tglx




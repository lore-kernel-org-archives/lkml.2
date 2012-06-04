Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2FDQ4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:56:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49223 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751989Ab2FDQ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:56:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Rr5Fan7eRM1k39QrbuWVJdQIVP0XMR1b1ZPNu2g
	6MhTHdB5wHz8y8
Message-ID: <1338828989.7363.8.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 18:56:29 +0200
In-Reply-To: <1338824014.28282.86.camel@twins>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
	 <1338801907.7356.163.camel@marge.simpson.net>
	 <1338810796.28282.32.camel@twins>
	 <1338814063.7356.192.camel@marge.simpson.net>
	 <20120604130740.GC25126@linux.vnet.ibm.com>
	 <1338820234.7356.250.camel@marge.simpson.net>
	 <20120604143802.GB26651@linux.vnet.ibm.com>
	 <1338820895.7356.252.camel@marge.simpson.net>
	 <20120604150040.GD25126@linux.vnet.ibm.com>
	 <1338823271.28282.75.camel@twins>
	 <20120604152522.GE26651@linux.vnet.ibm.com>
	 <1338824014.28282.86.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 17:33 +0200, Peter Zijlstra wrote:

> Now I'm not as opposed to this as Mike is, the load cpu_power thing can
> also happen due to excessive IRQ time, and hopefully we'll get to have
> an unpriv. SCHED_DEADLINE at some point as well.

I'm not heavily opposed, was just questioning the RT justification.

-Mike


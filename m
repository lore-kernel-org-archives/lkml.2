Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2BTTIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:08:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53519 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2BTTH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:07:58 -0500
Message-ID: <1329764866.2293.376.camel@twins>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 20:07:46 +0100
In-Reply-To: <1329761661.6276.146.camel@marge.simpson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1329748861.2293.345.camel@twins>
	 <1329761661.6276.146.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 19:14 +0100, Mike Galbraith wrote:
> Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
> Maybe that has changed, but I doubt it.

Right, I through I remembered some such, you could see it on wakeup
heavy things like pipe-bench and that java msg passing thing, right?



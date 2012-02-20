Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2BTRBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:01:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2BTRBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:01:51 -0500
Message-ID: <1329757291.2293.372.camel@twins>
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 18:01:31 +0100
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One more thing though, check what it all does when you run with the
'default' jiffies based sched_clock(). Nobody sane should use that, but
then there's bound to be people who disagree with that :-)

I suspect it will all more or less work out, but someone should verify
that it actually does. It would be such a shame to have to revert this
because we broken something daft like m68k or so ;-)

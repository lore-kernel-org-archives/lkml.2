Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2EKJFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:05:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:42841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab2EKJF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:05:26 -0400
Message-ID: <1336727094.2527.145.camel@twins>
Subject: Re: [PATCH v4 5/7] x86/tlb: add tlb flush all factor for specific
 CPU
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 11:04:54 +0200
In-Reply-To: <1336727058.2527.144.camel@twins>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
	 <1336626013-28413-6-git-send-email-alex.shi@intel.com>
	 <1336642715.2527.84.camel@twins> <4FAC621D.2020704@intel.com>
	 <1336727058.2527.144.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 11:04 +0200, Peter Zijlstra wrote:

> > NO, the first judgement is from CPU. But second '-1' is may from user
> > setting in sysfs.
> 
> Then you're doing it wrong. Don't allow setting the sysfs variable if !
> cpu_has_invlpg.

Better yet, don't create the sysfs file at all in that case.

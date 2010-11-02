Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0KBMaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:30:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:59831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0KBMaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:30:08 -0400
Subject: Re: [DRAFT PATCH 0/3] perf: Add Intel Nehalem uncore pmu support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com,
        Cyrill Gorcunov <gorcunov@gmail.com>, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        CoreyAshford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1288682858.12061.105.camel@minggr.sh.intel.com>
References: <1288682858.12061.105.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Nov 2010 13:29:30 +0100
Message-ID: <1288700970.2039.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 15:27 +0800, Lin Ming wrote:
> Any comment is very appreciated.

Right, so I was hoping to use the sysfs bits to expose things, I'll try
and get around to looking at your latest effort in that area soonish.
I'll try and sit down with gregkh one of these days to talk it over.

I'm not too sure about 1/3's change to x86_perf_event_update(), but its
not too aweful, the change to x86_perf_event_set_period() however does
look quite gruesome.

It might make sense to simple duplicate that code in the uncore bits,.
dunno.

2/3 looks ok, but I think it would be nice if it would be more self
contained, that is, not be part of the include mess and possibly have
its own NMI_DIE notifier entry.

All in all, Thanks for doing this, its a good start!



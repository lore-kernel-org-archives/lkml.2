Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1CHP5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:57:17 -0500
Received: from flusers.ccur.com ([173.221.59.2]:56057 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754836Ab1CHP5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:57:16 -0500
Date: Tue, 8 Mar 2011 10:57:10 -0500
From: Joe Korty <joe.korty@ccur.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] An RCU for SMP with a single CPU garbage collector
Message-ID: <20110308155710.GA15138@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110307210157.GG3104@linux.vnet.ibm.com>
 <20110307211613.GA26455@tsunami.ccur.com>
 <20110307225110.GA19414@tsunami.ccur.com>
 <20110308090742.GO3104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308090742.GO3104@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 04:07:42AM -0500, Paul E. McKenney wrote:
>> Thinking about it some more, the tap-into-syscall approach might
>> work in my implementation, in which case the tap-into-preempt-enable
>> code could go away.
> 
> OK, please let me know how that goes!
> 
>> Nice thing about RCU, the algorithms are infinitely mallable :)
> 
> Just trying to keep the code size finite.  ;-)

I hope to get to it this afternoon!  I especially like
the lockless nature of JRCU, and that the dedicated cpus
are not loaded down with callback inovcations either.
Not sure how to support the PREEMPT_RCU mode though; so
if Fredrick is planning to support that, that alone would
make his approach the very best.

Joe

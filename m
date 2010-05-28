Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0E1NnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:43:11 -0400
Received: from bar.sig21.net ([80.81.252.164]:39232 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab0E1NnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:43:06 -0400
Date: Fri, 28 May 2010 15:42:33 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched_clock: Provide local_clock() and improve
 documentation
Message-ID: <20100528134233.GA28190@sig21.net>
References: <4BF9EC69.5030709@example.com>
 <1274777422.5882.591.camel@twins>
 <20100526160252.325f8357.akpm@linux-foundation.org>
 <1274942798.27810.3584.camel@twins>
 <20100526235107.77e66ce0.akpm@linux-foundation.org>
 <1274945751.27810.3765.camel@twins>
 <20100527113340.d4afb8fc.akpm@linux-foundation.org>
 <1275052414.1645.52.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275052414.1645.52.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.711,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 03:13:34PM +0200, Peter Zijlstra wrote:
> + * The !IRQ-safetly of sched_clock() and sched_clock_cpu() comes from things

typo                ^

Thank you for adding documentation.  I have one additional
question regarding wrapping of sched_clock().  I know it is
used for timestamps in ftrace and printk, so it's desirable
that it never wraps.  But on several embedded systems
it wraps after a few hours.  Bug or just a minor flaw?
If someone knows it would be nice to get that documented, too.

See also
http://lkml.org/lkml/2010/4/26/340


Johannes

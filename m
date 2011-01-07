Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1AGTLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:11:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1AGTLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:11:19 -0500
Date: Fri, 7 Jan 2011 14:10:52 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] perf, x86: P4 PMU - Fix unflagged overflows
 handling v4
Message-ID: <20110107191052.GB26503@redhat.com>
References: <4D275E7E.3040903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D275E7E.3040903@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 09:42:06PM +0300, Cyrill Gorcunov wrote:
> Don found that P4 PMU reads CCCR register instead of counter
> itself (in attempt to catch unflagged event) this makes P4
> NMI handler to consume all NMIs it observes. So the other
> NMI users such as kgdb simply have no chance to get NMI
> on their hands.

Acked-by: Don Zickus <dzickus@redhat.com>

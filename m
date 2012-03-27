Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2C0WDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:03:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63314 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab2C0WDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:03:48 -0400
Date: Wed, 28 Mar 2012 02:03:43 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, p4: Add format attributes
Message-ID: <20120327220343.GG16537@moon>
References: <1332859842.16159.227.camel@twins>
 <20120327145728.GE11875@moon>
 <1332860759.16159.233.camel@twins>
 <20120327151250.GG11875@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327151250.GG11875@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 07:12:50PM +0400, Cyrill Gorcunov wrote:
> 
> Ah, I see thanks for the reference, Peter!
> 
> > I've still not actually read the P4-PMU specs, so I don't know if
> > there's anything more convenient we can do on P4. If there's a
> > better/more useful format representation possible, don't hesitate to
> > send a patch! :-)
> 
> Sure, I'll try to find some time tonight to read this brand
> new stuff. And if I find something -- will send out. At moment
> your patch should be more than enough ;)

Hi, Peter, sorry for delay,

after looking some more I think ht bit might be dropped from
the format, it's used internally by the kernel in attmept to
eliminate redundant msr poking if new event runs on the same
thread as previous one, and it's always cleared before real
write to msr happens, which means user-space might set or
clear it, but it never be considered by the kernel.

(still my earlier reviewed-by is valid because this ht bit
 is harmless ;)

	Cyrill

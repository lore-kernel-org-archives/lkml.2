Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1DUCqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:46:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1DUCqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:46:51 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=JnBRYxWsIEkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=AsrsT3K6e66PhwASTDYA:9 a=nZMR9Fj9UlEYINZ85skA:7 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 20 Apr 2011 22:46:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Hui Zhu <teawater@gmail.com>
Cc: Dongdong Deng <libfetion@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110405 release
Message-ID: <20110421024648.GA24898@home.goodmis.org>
References: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
 <1302024458.2225.1350.camel@twins>
 <BANLkTinU5s8FgC9acCPcQqDRBnwi4EqA2g@mail.gmail.com>
 <1302077959.2225.1378.camel@twins>
 <BANLkTimHwt=q4K9uMNX4kR6Q8LJhHHSysw@mail.gmail.com>
 <BANLkTimP-uhj7PQqgvpnedy_y9sQga99ug@mail.gmail.com>
 <BANLkTi=KZyi-e02Rc=agnVDOk+4=VLdZ-w@mail.gmail.com>
 <BANLkTi=BQVjXRLNxiCU0xaYrDShtRgiC6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=BQVjXRLNxiCU0xaYrDShtRgiC6Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 04:25:28PM +0800, Hui Zhu wrote:
> After a discussion with Dongdong, I think I have different idea with that.
> 
> 1. I don't want change the current interface of kgtp.  Because a proc
> interface is very simple and stable interface.
> And with proc, kgtp can very easy connect with GDB without Kernel

Can you use the debugfs interface instead of proc. Proc is too
overloaded as is, and debugfs seems to be a perfect match in this case.

-- Steve

> help.  Please see
> https://code.google.com/p/kgtp/wiki/HOWTO#Make_GDB_connect_to_gtp and
> https://code.google.com/p/kgtp/wiki/HOWTO#Offline_debug
> 
> 2. I don't want remove the kprobe.  Because what I want kgtp is to be
> a Linux Kernel tracepoint interface with gdb.  I will add other
> tracepoint like TRACE_EVENT.
> And move it to gdb breakpoint is too far away from it.  And it is too
> much depend on kgdb.
> 
> Of course, I am very happy to share the GDB rsp tracepoint parse code
> with kgdb to make it support gdb tracepoint.
> Trust me, My code is more clear than the doc of GDB.  :)
> 

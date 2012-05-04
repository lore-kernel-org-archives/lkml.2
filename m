Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2EDR76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab2EDR75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:59:57 -0400
Date: Fri, 4 May 2012 14:59:40 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/4] perf, tool: Fix endian issues
Message-ID: <20120504175940.GC29365@infradead.org>
References: <1336151493-8328-1-git-send-email-jolsa@redhat.com>
 <4FA41481.7000704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA41481.7000704@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 04, 2012 at 11:40:17AM -0600, David Ahern escreveu:
> On 5/4/12 11:11 AM, Jiri Olsa wrote:
> >hi,
> >sending fixies to properly handle perf.data endians.
> >
> >v2 changes:
> >   - added patches 3 and 4 to handle sample_id_all header endianity
> >
> >Attached patches:
> >   1/4 perf, tool: Handle different endians properly during symbol load
> >   2/4 perf, tool: Carry perf_event_attr bitfield throught different endians
> >   3/4 perf, tool: Handle endianity swap on sample_id_all header data
> >   4/4 perf, tool: Fix 32 bit values endianity swap for sample_id_all header
> 
> Have you tested these patches by collecting data on PPC (or other
> big endian) and analyzing on Intel x86 and vice versa?

I think so, but indeed it is good practice to show the sequence made to
test the changes, with sample, short command output before and after.

- Arnaldo

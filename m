Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1LTKcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:32:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab1LTKcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:32:18 -0500
Date: Tue, 20 Dec 2011 11:31:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
Message-ID: <20111220103154.GA1861@m.brq.redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
 <1324044159.18942.104.camel@twins>
 <1324044196.18942.105.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324044196.18942.105.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 03:03:16PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-12-16 at 15:02 +0100, Peter Zijlstra wrote:
> > > event_tracepoint:       PE_NAME_TP ':' PE_NAME_TP modifier
> > > event_raw:              PE_SEP_RAW PE_VALUE modifier
> > > event_numeric:          PE_VALUE ':' PE_VALUE modifier
> > > event_symbolic:         PE_NAME_SYM modifier
> > > event_generic_hw:       PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT modifier |
> > >                         PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT modifier |
> > >                         PE_NAME_CACHE_TYPE modifier
> > > event_breakpoint:       PE_SEP_BP ':' PE_VALUE event_breakpoint_type modifier
> > > event_breakpoint_type:  PE_MODIFIER_BPTYPE | empty
> > > modifier:               PE_MODIFIER_EVENT | empty
> > 
> > This isn't complete, we need means of specifying
> > perf_event_attr::config[12] when specifying a raw event. 
> 
> Also, it might make sense to think about how to specify sysfs events
> (which don't exist yet).

any idea/details/specifics how they might look like? ;)

jirka

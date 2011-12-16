Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab1LPOEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:04:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:34891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab1LPOEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:04:13 -0500
Message-ID: <1324044196.18942.105.camel@twins>
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 16 Dec 2011 15:03:16 +0100
In-Reply-To: <1324044159.18942.104.camel@twins>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
	 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
	 <1324044159.18942.104.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 15:02 +0100, Peter Zijlstra wrote:
> > event_tracepoint:       PE_NAME_TP ':' PE_NAME_TP modifier
> > event_raw:              PE_SEP_RAW PE_VALUE modifier
> > event_numeric:          PE_VALUE ':' PE_VALUE modifier
> > event_symbolic:         PE_NAME_SYM modifier
> > event_generic_hw:       PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT modifier |
> >                         PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT modifier |
> >                         PE_NAME_CACHE_TYPE modifier
> > event_breakpoint:       PE_SEP_BP ':' PE_VALUE event_breakpoint_type modifier
> > event_breakpoint_type:  PE_MODIFIER_BPTYPE | empty
> > modifier:               PE_MODIFIER_EVENT | empty
> 
> This isn't complete, we need means of specifying
> perf_event_attr::config[12] when specifying a raw event. 

Also, it might make sense to think about how to specify sysfs events
(which don't exist yet).

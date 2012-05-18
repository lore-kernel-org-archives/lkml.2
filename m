Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965803Ab2ERRT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:19:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965404Ab2ERRTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:19:25 -0400
Date: Fri, 18 May 2012 14:19:12 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
Message-ID: <20120518171911.GH2636@infradead.org>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
 <1337081295-10303-5-git-send-email-eranian@google.com>
 <4FB32032.3000509@gmail.com>
 <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
 <4FB67DE5.8050000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB67DE5.8050000@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 18, 2012 at 10:50:45AM -0600, David Ahern escreveu:
> On 5/16/12 1:41 AM, Stephane Eranian wrote:
> >On Wed, May 16, 2012 at 5:34 AM, David Ahern<dsahern@gmail.com>  wrote:
> >>I love the feature and it works nicely, but there has been push back on
> >>adding more synthesized events.  Also the size of the patch is a bit much to
> >>take in. If there is no objection to the synthesized can you break the patch
> >>up -- e.g., introduce the events in one, synthesis and processing functions
> >>in another, plug into the commands, ...
> >>
> >Without new synthesized events, you cannot make this work. This is by
> >construction
> >of the pipe mode. Meta-data has be be injected in the stream and
> >therefore it needs
> >PERF_RECORD_* types.
> 
> Understood. I don't object to synthesized events.
> 
> Arnaldo: preferences?

PeterZ was the one objecting to adding more userspace only events,
Peter?

- Arnaldo

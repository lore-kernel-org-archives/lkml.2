Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2GXOjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:39:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39934 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab2GXOjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:39:20 -0400
Date: Tue, 24 Jul 2012 16:39:15 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 09/11] perf top: error handling for counter creation
 should parallel perf-record
Message-ID: <20120724143915.GG6717@infradead.org>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-10-git-send-email-dsahern@gmail.com>
 <20120723181521.GD6717@infradead.org>
 <500EAAC2.2020802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500EAAC2.2020802@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 24, 2012 at 08:01:38AM -0600, David Ahern escreveu:
> On 7/23/12 12:15 PM, Arnaldo Carvalho de Melo wrote:
> >Em Fri, Jul 20, 2012 at 05:25:54PM -0600, David Ahern escreveu:
> >>+			if ((err == ENOENT || err == ENXIO)
> >>+				&& attr->type == PERF_TYPE_HARDWARE
> >>+				&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {

> >usual style:
> >			if ((err == ENOENT || err == ENXIO) &&
> >			    attr->type == PERF_TYPE_HARDWARE &&
> >			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {

> Right. I literally made it the same as builtin-record.c. I'll resubmit.

Ok, at some point we should fix that too, lowest prio tho, just trying
to avoid adding more.

- Arnaldo

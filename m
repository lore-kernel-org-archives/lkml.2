Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab2JaO0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:26:16 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:43997 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2JaO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:26:11 -0400
Date: Wed, 31 Oct 2012 07:26:00 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/25] perf tests: Add framework for automated
 perf_event_attr tests
Message-ID: <20121031142600.GB28061@ghostprotocols.net>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
 <1351634526-1516-4-git-send-email-jolsa@redhat.com>
 <20121030230120.GA1067@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030230120.GA1067@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 31, 2012 at 12:01:20AM +0100, Jiri Olsa escreveu:
> On Tue, Oct 30, 2012 at 11:01:44PM +0100, Jiri Olsa wrote:
> > Adding automated test to check event's perf_event_attr values.
> 
> SNIP
> 
> > +
> > +void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
> > +		     int fd, int group_fd, unsigned long flags)
> > +{
> > +	if (store_event(attr, pid, cpu, fd, group_fd, flags))
> > +		die("test attr FAILED");
> > +}
> 
> ahh crap, I forgot the errno value preservation fix.. 
> 
> I'd send it later with another fix I have for perf stat or v2 if needed ;-)

Send just a v2 for this specific patch.

- Arnaldo

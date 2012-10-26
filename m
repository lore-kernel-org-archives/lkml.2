Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321Ab2JZQZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:25:39 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49988 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965226Ab2JZQZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:25:37 -0400
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read
 support
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <508AB6FC.3080904@gmail.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	 <87txti81i2.fsf@sejong.aot.lge.com> <1351242885.16863.0.camel@twins>
	 <20121026102336.GA1067@krava.brq.redhat.com>
	 <1351265946.1619.20.camel@leonhard>  <508AB6FC.3080904@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Oct 2012 01:25:30 +0900
Message-ID: <1351268730.1619.21.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-26 (금), 10:14 -0600, David Ahern:
> On 10/26/12 9:39 AM, Namhyung Kim wrote:
> >> hm, thats the unique sample_type issue again ;) Once we set
> >> PERF_SAMPLE_READ for event or group, we need to set it for
> >> all other events in session, otherwise the report fails
> >
> > Sorry, I don't understand why we need to set it for all events.  Just
> > setting it for a group is not sufficient?  Please shed some light on
> > this.
> 
> perf does not support multiple sample_types -- all events in the session 
> need to use the same one.

Can I ask why? :)

Thanks,
Namhyung



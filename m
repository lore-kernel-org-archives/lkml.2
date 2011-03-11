Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1CKA2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:28:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56560 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1CKA2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:28:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=sQvONjT0v5FDJDLaUYcNjwDXvc0f3QtDY+GdEvsaAPtjkpWqEEBqcMDWwEtLxt1QD5
         s6tKef83eHCj/gmURF2TwujmJV3btz6yYYMEgmWROT+N/iLN0uqUtMGCGQkcWOoknu2x
         n0cUfRiPip/AggEXSzxTj4vkr8xlm4NqxB7G4=
Date: Fri, 11 Mar 2011 01:28:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Ahern <daahern@cisco.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, paulus@samba.org,
        tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf script: move printing of 'common' data from
 print_event and rename
Message-ID: <20110311002812.GA2023@nowhere>
References: <1299734608-5223-1-git-send-email-daahern@cisco.com>
 <1299734608-5223-4-git-send-email-daahern@cisco.com>
 <20110310152053.GB12521@home.goodmis.org>
 <20110310155109.GB23555@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110310155109.GB23555@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 12:51:09PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Mar 10, 2011 at 10:20:53AM -0500, Steven Rostedt escreveu:
> > On Wed, Mar 09, 2011 at 10:23:25PM -0700, David Ahern wrote:
> > > This change does impact output: latency data is trace specific and is now
> > > printed after the common data - comm, tid, cpu, time and event name.
> 
> > > Signed-off-by: David Ahern <daahern@cisco.com>
> 
> > >  tools/perf/builtin-script.c         |   38 ++++++++++++++++++++++-----
> > >  tools/perf/util/trace-event-parse.c |   49 +++++++---------------------------
> 
> > I was hoping after the next merge window to start making a common library
> > for parsing events. This way things like powertop and timechart or
> > anything that uses the perf interface does not need to write its own
> > parsing of events, or expect the event formats to be hardcoded.
> > 
> > The trace-event-parse.c was taking from trace-cmd's parse-events.c code
> > and hopefully the two can merge again. The parse-events.c code in
> > trace-cmd has gone through several iterations that has made it much more
> > robust and flexible. I purposely kept it as a separate libarary not
> > dependent on trace-cmd so that it could be used by other utilities like
> > perf.
> 
> David is kinda new to this perf/ftrace/trace-cmd/etc soap opera, and he
> has been patient to go thru the motions with Peter, Thomas, Frédéric and
> me, going from doing what he wants in 'perf report' to 'perf script',
> etc.
> 
> We're almost to the point where his feature is implemented in a
> way Frédéric, the one most actively reviewing his work, is satisfied,
> right Frédéric?

Yeah, nice work! Thanks David!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

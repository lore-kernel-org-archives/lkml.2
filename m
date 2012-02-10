Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab2BJSGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:06:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65005 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2BJSGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:06:03 -0500
Date: Fri, 10 Feb 2012 19:05:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCHv8 0/8] ftrace, perf: Adding support to use function trace
Message-ID: <20120210180555.GD25516@somewhere.redhat.com>
References: <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1328643899-8361-1-git-send-email-jolsa@redhat.com>
 <1328880444.8273.3.camel@gandalf.stny.rr.com>
 <1328885120.8273.7.camel@gandalf.stny.rr.com>
 <20120210160756.GB6145@m.redhat.com>
 <20120210164837.GC25516@somewhere.redhat.com>
 <1328896815.8273.8.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328896815.8273.8.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 01:00:15PM -0500, Steven Rostedt wrote:
> On Fri, 2012-02-10 at 17:48 +0100, Frederic Weisbecker wrote:
> 
> > Stephane Eranian has reported a similar problem but perhaps not with
> > the same cause.
> > 
> > I need to have a look.
> 
> Not sure if this is related, but the "script" output of the problem
> perf.dat file had this warning:
> 
> Warning: Timestamp below last timeslice flush

Yup, that's what I'm looking at.

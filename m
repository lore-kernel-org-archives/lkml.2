Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1GNVij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:38:39 -0400
Received: from ozlabs.org ([203.10.76.45]:54493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNVii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:38:38 -0400
From: Michael Neuling <mikey@neuling.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Sonny Rao <sonnyrao@chromium.org>, acme@redhat.com, anton@samba.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv3] perf: robustify proc and debugfs file recording
In-reply-to: <1310647558.27864.19.camel@gandalf.stny.rr.com>
References: <28585.1310602685@neuling.org> <1310604019-10935-1-git-send-email-sonnyrao@chromium.org> <1310612277.27864.5.camel@gandalf.stny.rr.com> <10011.1310614483@neuling.org> <1310647558.27864.19.camel@gandalf.stny.rr.com>
Comments: In-reply-to Steven Rostedt <rostedt@goodmis.org>
   message dated "Thu, 14 Jul 2011 08:45:58 -0400."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 07:38:36 +1000
Message-ID: <23957.1310679516@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1310647558.27864.19.camel@gandalf.stny.rr.com> you wrote:
> On Thu, 2011-07-14 at 13:34 +1000, Michael Neuling wrote:
> > In message <1310612277.27864.5.camel@gandalf.stny.rr.com> you wrote:
> > > On Wed, 2011-07-13 at 17:40 -0700, Sonny Rao wrote:
> > > > While attempting to create a timechart of boot up I found
> > > > perf didn't tolerate modules being loaded/unloaded.  This patch
> > > > fixes this by reading the file once and then writing the size
> > > > read at the correct point in the file.  It also simplifies the
> > > > code somewhat.
> > > > 
> > > 
> > > I get this:
> > > 
> > > cc1: warnings being treated as errors
> > > util/trace-event-info.c: In function ‘read_header_files’:
> > > util/trace-event-info.c:221: error: unused variable ‘size’
> > > util/trace-event-info.c: In function ‘copy_event_system’:
> > > util/trace-event-info.c:255: error: unused variable ‘size’
> > > make: *** [/tmp/build/util/trace-event-info.o] Error 1
> > 
> > Looks like sonny didn't pick up my changes correctly.  Here's the
> > working I tested with the sizep and warnings cleanups.
> 
> Hmm, your patch has some serious issues caused by your mail client. When
> saving (or looking at the raw message) I get this:

Crap, sorry.  

This is the same mail client I've used for sending patches for donkeys
years so something much have under the covers with a distro upgrade or
some such.  

Mikey

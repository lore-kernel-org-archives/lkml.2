Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2EXUFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:05:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab2EXUFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:05:47 -0400
Date: Thu, 24 May 2012 16:05:41 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: tracing ring_buffer_resize oops.
Message-ID: <20120524200541.GA6552@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>
References: <20120524160146.GA6226@redhat.com>
 <1337876398.13348.178.camel@gandalf.stny.rr.com>
 <20120524172223.GA10689@redhat.com>
 <1337880914.13348.189.camel@gandalf.stny.rr.com>
 <20120524184728.GA13201@redhat.com>
 <1337885672.13348.194.camel@gandalf.stny.rr.com>
 <20120524191147.GA13936@redhat.com>
 <1337887495.13348.195.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337887495.13348.195.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 03:24:55PM -0400, Steven Rostedt wrote:
 > On Thu, 2012-05-24 at 15:11 -0400, Dave Jones wrote:
 > 
 > >  > Also, how reproducible is it? When it triggered for me, it was constant.
 > >  > Every boot and test failed. But after I did the make mrproper, I have
 > >  > not been able to trigger it again. This is why I put it down as a bad
 > >  > build.
 > > 
 > > happens every time for me so far.
 > 
 > Did you also do a make mrproper and try again?

ok, that's nasty.  Works fine after a make clean.

	Dave


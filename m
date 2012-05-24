Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab2EXTLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:11:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab2EXTLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:11:53 -0400
Date: Thu, 24 May 2012 15:11:47 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: tracing ring_buffer_resize oops.
Message-ID: <20120524191147.GA13936@redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337885672.13348.194.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:54:32PM -0400, Steven Rostedt wrote:
 > On Thu, 2012-05-24 at 14:47 -0400, Dave Jones wrote:
 > > On Thu, May 24, 2012 at 01:35:14PM -0400, Steven Rostedt wrote:
 > > 
 > >  > Hmm, I wonder if this is the break point change :-/
 > >  > 
 > >  > Do you have NMIs enabled? I didn't have 'paranoid_exit' in my backtrace
 > >  > when I saw the bug.
 > > 
 > > $ grep NMI .config
 > > CONFIG_OPROFILE_NMI_TIMER=y
 > > CONFIG_HAVE_PERF_EVENTS_NMI=y
 > > CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
 > > CONFIG_HPWDT_NMI_DECODING=y
 > > # CONFIG_DEBUG_NMI_SELFTEST is not set
 > 
 > Could you email your entire config. I haven't been able to trigger the
 > bug again. Maybe your config might do it :-/

http://fpaste.org/BTN7/raw/

 > Also, how reproducible is it? When it triggered for me, it was constant.
 > Every boot and test failed. But after I did the make mrproper, I have
 > not been able to trigger it again. This is why I put it down as a bad
 > build.

happens every time for me so far.

	Dave 

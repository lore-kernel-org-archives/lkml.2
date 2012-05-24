Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140Ab2EXSrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab2EXSre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:47:34 -0400
Date: Thu, 24 May 2012 14:47:28 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: tracing ring_buffer_resize oops.
Message-ID: <20120524184728.GA13201@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>
References: <20120524160146.GA6226@redhat.com>
 <1337876398.13348.178.camel@gandalf.stny.rr.com>
 <20120524172223.GA10689@redhat.com>
 <1337880914.13348.189.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337880914.13348.189.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:35:14PM -0400, Steven Rostedt wrote:

 > Hmm, I wonder if this is the break point change :-/
 > 
 > Do you have NMIs enabled? I didn't have 'paranoid_exit' in my backtrace
 > when I saw the bug.

$ grep NMI .config
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set


	Dave


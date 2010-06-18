Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab0FRPSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:18:48 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:54727 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932219Ab0FRPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:18:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANspG0xGGOJc/2dsb2JhbACfEHLCQIUbBA
Date: Fri, 18 Jun 2010 11:18:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 00/13] jump label v9
Message-ID: <20100618151842.GA26185@Krystal>
References: <cover.1276116186.git.jbaron@redhat.com> <20100614.204759.226765762.davem@davemloft.net> <20100615142811.GB2750@redhat.com> <20100615154440.GA9224@Krystal> <20100618034539.GD16706@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100618034539.GD16706@ozlabs.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:18:25 up 72 days,  1:11,  3 users,  load average: 0.21, 0.13,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Breeds (tony@bakeyournoodle.com) wrote:
> On Tue, Jun 15, 2010 at 11:44:40AM -0400, Mathieu Desnoyers wrote:
> 
> > It makes me wonder if anyone had success building a gcc 4.5
> > Intel-to-sparc64 cross-compiler ? Usually, the crosstool-like suites are
> > a few versions behind. I'm aware that this is not trivial, as
> > cross-compilers have a tendency to refuse to get built in certain
> > occasions (such as being a recent less tested version). I'd recommend
> > you focus on this as a first step before resubmitting.
> 
> I'm building (and uploading to kernel.org[1]) 4.4.4 and 4.5.0 toolchains.
> They're untested on anything otyher than the system I built them on.

Cool !!!

Thanks a lot Tony.

Mathieu

> 
> Give it 24 hours and then try'em
> 
> Yours Tony
> [1] http://kernel.org/pub/tools/crosstool/files/bin/${host_arch}/ [2]
> [2] currently only i686 and x86_64, powerpc64 are comming.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

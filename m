Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0D1Buk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:50:40 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:35481 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab0D1BuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:50:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALMs10tGGNqG/2dsb2JhbACcY3K/IYUOBA
Date: Tue, 27 Apr 2010 21:49:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>, jbaron@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, vgoyal@redhat.com, dank@kegel.com
Subject: Re: [PATCH 00/11] jump label v7
Message-ID: <20100428014941.GA8389@Krystal>
References: <cover.1271427118.git.jbaron@redhat.com> <20100422.161700.191166551.davem@davemloft.net> <20100427.175858.134109609.davem@davemloft.net> <20100428013951.GM12389@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100428013951.GM12389@ozlabs.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 21:44:04 up 20 days, 11:37,  4 users,  load average: 0.07, 0.14,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Breeds (tony@bakeyournoodle.com) wrote:
> On Tue, Apr 27, 2010 at 05:58:58PM -0700, David Miller wrote:
> 
> > The kernel stops compiling after the second patch because
> > kernel/jump_label.c is compiled unconditionally, and this generates an
> > attempt to include asm/alternatives.h which is an x86-only phenomenon.
> > 
> > Do you have access to a cross-compile environment or at least some
> > non-x86 system you can test build on before submitting these patch
> > sets?
> 
> I heard cross-compilers?
> 
> http://kernel.org/pub/tools/crosstool/files/bin/  i686 and x86_64 and 4.4.0
> compilers suitable for kernel work.
> 
> I plan to build 4.4.$latest and 4.5.0 ASAP.
> 
> Yours Tony

The crosstool package from Dan Kegel did a good job for this. Not sure
it's currently maintained though. It was a very useful project, it's a
shame if it does not live on. It would be good to have up-to-date and
tested compilers for various architectures available on kernel.org,
ideally with access to a package that helps building compilers for
various architectures.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

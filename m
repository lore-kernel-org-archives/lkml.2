Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1BJMni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:43:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46768 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751123Ab1BJMng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:43:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+QmDwXTWSQDOaZqJito1hXVh3Rs5GPvB7dScn1T6
	Ay/cPNEzpKFMIa
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
 regression
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@redhat.com,
        hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110210121559.GA26094@elte.hu>
References: <new-submission>
	 <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org>
	 <1297224378.8035.7.camel@marge.simson.net>
	 <20110209164154.GA15607@ghostprotocols.net>
	 <1297309313.7996.11.camel@marge.simson.net>
	 <20110210121559.GA26094@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 13:43:31 +0100
Message-ID: <1297341811.5512.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 13:15 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > Initial impression: can I have a pony too? :)
> > 
> > I like this a lot, great for live rummaging.  One thing that would help with large 
> > files maybe - a jump to next spot hotter than N%, but as is is quite nice.
> > 
> > I managed to lock it up once, but shiny new gizmos usually do hiccup.
> 
> The TUI locked up or the kernel? If it's the TUI then a gdb dump of the lockup would 
> be nice.

TUI stopped responding to my key poking.  I'll see if it'll repeat
(weekend).

	-Mike


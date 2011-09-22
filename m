Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1IVOlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:41:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58322 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753184Ab1IVOld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:41:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18N9G0K9qsN4GmhOT5HeN3aGngy0qS+JhDt7xhNSQ
	To58VWxGw3O8G9
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
In-Reply-To: <1316702297.5455.1.camel@marge.simson.net>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net> <1316685640.31429.2.camel@twins>
	 <1316692534.6284.46.camel@marge.simson.net>
	 <1316693391.31429.12.camel@twins>
	 <1316698943.6348.8.camel@marge.simson.net>
	 <1316702080.31429.13.camel@twins>
	 <1316702297.5455.1.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 16:41:29 +0200
Message-ID: <1316702489.5455.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 16:38 +0200, Mike Galbraith wrote:
> On Thu, 2011-09-22 at 16:34 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-09-22 at 15:42 +0200, Mike Galbraith wrote:
> > > #include <cpuset.h>
> > 
> > I don't seem to have that, where does that come from?
> 
> libcpuset-devel.

But you don't need it.  That's a leftover from a version that could move
itself into a shielded cpuset.

	-Mike


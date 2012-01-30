Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2A3Pat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:30:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63009 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2A3Paq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:30:46 -0500
Date: Mon, 30 Jan 2012 13:30:40 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Steets <asteets@rgmadvisors.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Message-ID: <20120130153040.GB15935@infradead.org>
References: <4F22D8D9.3010108@rgmadvisors.com>
 <20120128120151.GA10390@elte.hu>
 <4F248938.5030507@rgmadvisors.com>
 <20120129163235.GB23408@elte.hu>
 <1327917156.2446.191.camel@twins>
 <20120130101121.GB8924@elte.hu>
 <1327921293.2446.202.camel@twins>
 <20120130113115.GA6565@elte.hu>
 <1327931107.2446.205.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327931107.2446.205.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 30, 2012 at 02:45:07PM +0100, Peter Zijlstra escreveu:
> On Mon, 2012-01-30 at 12:31 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > On Mon, 2012-01-30 at 11:11 +0100, Ingo Molnar wrote:
> > > > So, what workflow are you suggesting to Andrew?
> > > Librarize perf record, then in your code do something like:
> > > #include "perf_record.h"

> > Maybe. (and then it shouldnt be limited to perf_record.h but 
> > should be events.h plus libevents.so or such)

> Yes it should be, you want to reserve the more generic name for less
> narrow interfaces.

Agreed.
 
- Arnaldo

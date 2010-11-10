Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0KJOyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:54:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:56066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab0KJOya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:54:30 -0500
Subject: Re: [RFC PATCH 1/2] perf: Enable group siblings on exec if
 attr::enable_on_exec set
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289400543.2479.41.camel@localhost>
References: <1289369711.2430.38.camel@minggr.sh.intel.com>
	 <1289391586.2191.100.camel@laptop>  <1289398677.2479.10.camel@localhost>
	 <1289399915.2191.127.camel@laptop>  <1289400543.2479.41.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 15:54:42 +0100
Message-ID: <1289400882.2191.136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 22:49 +0800, Lin Ming wrote:
> > I don't mind the patch too much (although I would like to avoid that
> > double sibling iteration in both group_enable_on_exec() and
> > __perf_event_mark_enabled()), but I think it can already work as is.
> 
> I got it now!
> 
> Another stupid patch, sorry. 

Well, I wouldn't call it a stupid patch, it does fix something that is
evidently non-obvious so it might be worth considering it on that merit.

I'm simply pointing out that what you're trying to achieve might be
possible without changing code.

 

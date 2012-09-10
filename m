Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2IJXKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:10:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57345 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab2IJXKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:10:31 -0400
Date: Mon, 10 Sep 2012 16:10:05 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] perf: Add cpumask for uncore pmu
Message-ID: <20120910231005.GA29169@ghostprotocols.net>
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
 <1347294866.2124.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347294866.2124.28.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 10, 2012 at 06:34:26PM +0200, Peter Zijlstra escreveu:
> On Mon, 2012-09-10 at 15:53 +0800, Yan, Zheng wrote:
> > This patchset add a cpumask file to the uncore pmu sysfs directory.
> > If user doesn't explicitly specify CPU list, perf-stat only collects
> > uncore events on CPUs listed in the cpumask file.

> > As Stephane suggested, make perf-stat recognize wildcard in pmu name.
> > So we can easily measure event on all uncore boxes of same type.

> > Any comment is appreciated.
 
> You forgot to CC acme who maintains the tools side.. Anyway, I think it
> all looks ok, Arnaldo see anything dubious in there?

I'll look at that tomorrow, when my caffeine level is high and the other
substance is down, thanks.

- Arnaldo

P.S. thanks for pointing the (l)userlevel part, much appreciated.

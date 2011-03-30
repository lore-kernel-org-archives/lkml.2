Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1C3CTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:19:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:38191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1C3CTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:19:24 -0400
Date: Tue, 29 Mar 2011 23:18:54 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH] perf report: add sort by file lines
Message-ID: <20110330021854.GD20824@ghostprotocols.net>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
 <1301392457.4859.74.camel@twins>
 <1301417155.3620.8.camel@localhost>
 <1301418183.2250.416.camel@laptop>
 <1301418404.2250.417.camel@laptop>
 <1301418533.2250.419.camel@laptop>
 <20110329174556.GC24129@ghostprotocols.net>
 <4D92818A.8020405@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D92818A.8020405@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 30, 2011 at 10:04:10AM +0900, Masami Hiramatsu escreveu:
> So that what we need is a kind of the reverse compiler which generates
> intermediate code (a sequence of register assignments) from
> instruction code. That's not impossible task, but just hard and fun. :)
> For that purpose, we'll need an instruction decoder and an evaluator
> which allows us to trace the sequence of address dereferences.
> 
> Anyway, I'd recommend that we should start with just showing
> the corresponding "source line" of the address. It may be
> enough for some cases.

Right, but being able to map events to structure fields is an interestig
goal, data annotation instead of code annotation, and if it is fun and
hard, even better! :-)

- Arnaldo

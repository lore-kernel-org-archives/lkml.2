Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab2K3Nu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:50:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932974Ab2K3Nu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:50:56 -0500
Date: Fri, 30 Nov 2012 13:50:52 +0000
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: MMTests 0.08
Message-ID: <20121130135052.GE20087@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MMTests 0.08 is a configurable test suite that runs a number of common
workloads of interest to MM developers. This release is very monitor but
contains some specjbb configs for running with a single JVM and preliminary
support for rendering reports as HTML.

Changelog since v0.07
o Preliminary support for rendering HTML reports
o specjbb configs for single JVMs
o specjbb extraction script changes for single JVMs
o nas reporting scripts

At LSF/MM at some point a request was made that a series of tests
be identified that were of interest to MM developers and that could be
used for testing the Linux memory management subsystem. There is renewed
interest in some sort of general testing framework during discussions for
Kernel Summit 2012 so here is what I use.

http://www.csn.ul.ie/~mel/projects/mmtests/
http://www.csn.ul.ie/~mel/projects/mmtests/mmtests-0.08-mmtests-0.01.tar.gz

There is a git repository at

https://github.com/gormanm/mmtests.git

There are a number of stock configurations stored in configs/.  For example
config-global-dhp__pagealloc-performance runs a number of tests that
may be able to identify performance regressions or gains in the page
allocator. Similarly there network and scheduler configs. There are also
more complex options. config-global-dhp__parallelio-memcachetest will run
memcachetest in the foreground while doing IO of different sizes in the
background to measure how much unrelated IO affects the throughput of an
in-memory database.

Out of the box it should now do something useful by running a page fault
microbenchmark.

-- 
Mel Gorman
SUSE Labs

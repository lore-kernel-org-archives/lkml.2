Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0DSJ2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:28:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab0DSJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:27:59 -0400
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Gary.Mohr@Bull.com" <Gary.Mohr@Bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Stephane Eranian <eranian@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271668085.3730.2.camel@minggr.sh.intel.com>
References: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
	 <1271424250.4807.2277.camel@twins>
	 <1271668085.3730.2.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 11:27:56 +0200
Message-ID: <1271669276.1674.619.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 17:08 +0800, Lin Ming wrote:

> I have been also looking at this for some time.
> I'll send a draft patch later this week to support multiple hw pmus.

Well, that's going to be a mighty large patch.

I'd rather see smaller patches, say one patch per removal of a weak
hw_perf interface, etc...


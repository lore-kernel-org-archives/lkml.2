Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2FDPZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:25:36 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38386 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2FDPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:25:35 -0400
Date: Mon, 4 Jun 2012 20:55:22 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
Message-ID: <20120604152522.GE26651@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
 <1338801907.7356.163.camel@marge.simpson.net>
 <1338810796.28282.32.camel@twins>
 <1338814063.7356.192.camel@marge.simpson.net>
 <20120604130740.GC25126@linux.vnet.ibm.com>
 <1338820234.7356.250.camel@marge.simpson.net>
 <20120604143802.GB26651@linux.vnet.ibm.com>
 <1338820895.7356.252.camel@marge.simpson.net>
 <20120604150040.GD25126@linux.vnet.ibm.com>
 <1338823271.28282.75.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338823271.28282.75.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060415-5816-0000-0000-000002FFAFE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-06-04 17:21:11]:

> That is not to say you couldn't contrive a scenario where it would be
> needed.. 

Right ..what if B0. B1 are pinned? !! I think most of the current
weakness lies in handling tasks that have affinity set.

- vatsa


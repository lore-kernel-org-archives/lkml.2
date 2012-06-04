Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2FDRhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:37:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45431 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab2FDRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:37:39 -0400
Date: Mon, 4 Jun 2012 23:07:32 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
Message-ID: <20120604173732.GA909@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1338814063.7356.192.camel@marge.simpson.net>
 <20120604130740.GC25126@linux.vnet.ibm.com>
 <1338820234.7356.250.camel@marge.simpson.net>
 <20120604143802.GB26651@linux.vnet.ibm.com>
 <1338820895.7356.252.camel@marge.simpson.net>
 <20120604150040.GD25126@linux.vnet.ibm.com>
 <1338823271.28282.75.camel@twins>
 <20120604152522.GE26651@linux.vnet.ibm.com>
 <1338824014.28282.86.camel@twins>
 <1338828989.7363.8.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338828989.7363.8.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060417-4790-0000-0000-0000031407CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-06-04 18:56:29]:

> I'm not heavily opposed, was just questioning the RT justification.

We will update the changelog to indicate all the scenarios/possibilities
discussed and publish the next version shortly.

- vatsa 


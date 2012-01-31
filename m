Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2AaUD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:03:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41764 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2AaUD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:03:27 -0500
Message-ID: <1328040199.2446.243.camel@twins>
Subject: RE: [PATCH] scheduler: domain: init next_balance in
 nohz_idle_balancer with jiffies
From: Peter Zijlstra <peterz@infradead.org>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Kamalesh Babulal'" <kamalesh@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 21:03:19 +0100
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE466523791832BE8@HQMAIL04.nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
	 <1328024684.2446.234.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE466523791832BE8@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 11:18 -0800, Diwakar Tundlam wrote:
> Yes, the change should be ported to kernel/sched/fair.c under
> init_sched_fair_class(). But that's for 3.3. I will send a separate
> patch for 3.3 shortly.
> 
Patches are sent against the current (3.3-rc) or next (3.4) development
trees, anything older can possibly get backports through the stable
stuff but is completely irrelevant for patch submission.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1BOJQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:16:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1BOJQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:16:04 -0500
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@gmail.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
In-Reply-To: <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	 <1296854731-25039-1-git-send-email-venki@google.com>
	 <1297086642.13327.15.camel@laptop>
	 <AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
	 <1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1297266928.13327.216.camel@laptop>
	 <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 10:15:26 +0100
Message-ID: <1297761326.2401.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 17:20 -0800, Suresh Siddha wrote:
> I will request Alex and Tim to run their
> performance workloads to make sure that this doesn't show any
> regressions.

Are those workloads public? If so which are they?

It would be good if all of us working on this could use them.. :-)

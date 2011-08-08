Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1HHI5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:57:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:1045 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab1HHI5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:57:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,336,1309762800"; 
   d="scan'208";a="36329685"
Subject: Re: [PATCH v2 6/6] perf tool: Parse general/raw events from sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1312793298.10488.2.camel@twins>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-7-git-send-email-ming.m.lin@intel.com>
	 <CABPqkBRTw5mcHn29gba8OyeUfMuGU3mQcKsrADug1401n6j0kw@mail.gmail.com>
	 <1312673888.2664.18.camel@hp6530s>
	 <CABPqkBTp_R6RRUdkYwB5O6HN6i05V=4eV3Pb2NaS3KZUhBN7fg@mail.gmail.com>
	 <1312765681.3938.1668.camel@minggr.sh.intel.com>
	 <1312793298.10488.2.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 16:57:46 +0800
Message-ID: <1312793866.4115.5.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 16:48 +0800, Peter Zijlstra wrote:
> On Mon, 2011-08-08 at 09:08 +0800, Lin Ming wrote:
> > 
> > We only need to register one pmu with two same graphics cards.
> > Then we can overload pid argument of sys_perf_event_open() to
> > differentiate each instance of graphic card.
> > 
> > Just like perf cgroup does. 
> 
> I don't like that much at all.. For one it will make it impossible to
> put the pmu device in the right sysfs topology.

So do you prefer adding a number to gpu name, as Stephane mentioned?



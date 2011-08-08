Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab1HHIsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:48:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:34352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1HHIsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:48:46 -0400
Subject: Re: [PATCH v2 6/6] perf tool: Parse general/raw events from sysfs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 08 Aug 2011 10:48:18 +0200
In-Reply-To: <1312765681.3938.1668.camel@minggr.sh.intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-7-git-send-email-ming.m.lin@intel.com>
	 <CABPqkBRTw5mcHn29gba8OyeUfMuGU3mQcKsrADug1401n6j0kw@mail.gmail.com>
	 <1312673888.2664.18.camel@hp6530s>
	 <CABPqkBTp_R6RRUdkYwB5O6HN6i05V=4eV3Pb2NaS3KZUhBN7fg@mail.gmail.com>
	 <1312765681.3938.1668.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312793298.10488.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 09:08 +0800, Lin Ming wrote:
> 
> We only need to register one pmu with two same graphics cards.
> Then we can overload pid argument of sys_perf_event_open() to
> differentiate each instance of graphic card.
> 
> Just like perf cgroup does. 

I don't like that much at all.. For one it will make it impossible to
put the pmu device in the right sysfs topology.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1DXPCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 11:02:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:19403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab1DXPCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 11:02:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,263,1301900400"; 
   d="scan'208";a="737696365"
Subject: Re: [2.6.39-rc2] perf top fails to mmap - bisected to 70db7533
From: Lin Ming <ming.m.lin@intel.com>
To: David Ahern <dsahern@gmail.com>
Cc: Tim Blechmann <tim@klingt.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4DB42988.7060607@gmail.com>
References: <inhgjs$54a$1@dough.gmane.org>
	 <BANLkTikWpnnHAfO2n2rN6ExtQyrsVaiqEQ@mail.gmail.com>
	 <1303570271.3363.4.camel@localhost> <201104241347.52486.tim@klingt.org>
	 <4DB42988.7060607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 23:02:04 +0800
Message-Id: <1303657324.2239.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-24 at 21:45 +0800, David Ahern wrote:
> 
> On 04/24/11 05:47, Tim Blechmann wrote:
> >>>> I know you've been busy with other stuff the past few weeks, but have
> >>>> you had a chance to look into this? Basically, perf in 2.6.39 is broken
> >>>> when trying to profile a process (-p argument to record or top).
> >>>
> >>> Let me take a look at this.
> >>
> >> Below patch fixes the same problem on my box.
> >> Could you have a try it?
> > 
> > i have done some quick tests with this patch applied on linus/master ... works 
> > fine for me, thanks a lot!
> 
> Works for me as well.

Thanks for test.

I have send out the format patch.
http://marc.info/?l=linux-kernel&m=130365710014862&w=2

Lin Ming

> 
> > 
> >> >From 89f1ab02cd8da55f8829b2f2d7e700fdae77b3af Mon Sep 17 00:00:00 2001
> >>
> >> From: Lin Ming <ming.m.lin@intel.com>
> >> Date: Sat, 23 Apr 2011 14:54:33 +0000
> >> Subject: [PATCH] perf: Allow set output event for task in the same thread
> >> group
> >>
> >> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > 
> > Tested-by: Tim Blechmann <tim@klingt.org>
> > 
> > cheers, tim
> > 



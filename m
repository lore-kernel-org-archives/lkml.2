Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1ACPVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:21:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49340 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab1ACPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:21:21 -0500
Date: Mon, 3 Jan 2011 16:21:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
Message-ID: <20110103152120.GC25713@one.firstfloor.org>
References: <1293464211.2695.104.camel@localhost> <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com> <1293526288.2457.4.camel@minggr.sh.intel.com> <1294052312.2016.50.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294052312.2016.50.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not quite sure, the intel docs aren't really clear on how the HW
> supports HT, has 2 siblings but BIOS disabled it thing works. I just
> tried reading the arch/x86 code but that only got me more confused.

... or you just keep the original code which works fine in any case
without this.

-Andi

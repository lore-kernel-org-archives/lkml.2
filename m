Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1GDWBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 18:01:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59594 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1GDWBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 18:01:24 -0400
Date: Tue, 5 Jul 2011 00:01:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
Message-ID: <20110704220123.GJ15637@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com> <1309766525-14089-2-git-send-email-ming.m.lin@intel.com> <1309768420.3282.8.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309768420.3282.8.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Did anybody check with the other PMUs that have similar features like
> PowerPC and possibly IA64?

IA64 has a similar feature I believe, but I'm not aware of anyone
working on that.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

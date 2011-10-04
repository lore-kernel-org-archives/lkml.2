Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab1JDNSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:18:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab1JDNSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:18:05 -0400
Date: Tue, 4 Oct 2011 15:18:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20111004131800.GD14482@one.firstfloor.org>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com> <1316778523.9084.17.camel@twins> <20110923122014.GP6063@erda.amd.com> <m2hb42ki5a.fsf@firstfloor.org> <CABPqkBRPvKxkyH6tVK1AQDBTbyrE3Cy0wjz64qaE2p0dzPRYig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRPvKxkyH6tVK1AQDBTbyrE3Cy0wjz64qaE2p0dzPRYig@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is Lin Ming's patch to expose PEBS Load Latency information.
> I will post a patch to export more of the machine state later on.

I have some patches to expose LBR and raw PEBS (similar to Robert's 
IBS patches, just for PEBS). But the user code still needs more work for that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

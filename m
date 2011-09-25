Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1IYP0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 11:26:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1IYP0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 11:26:12 -0400
Date: Sun, 25 Sep 2011 17:26:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20110925152607.GX7761@one.firstfloor.org>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com> <1316778523.9084.17.camel@twins> <20110923122014.GP6063@erda.amd.com> <m2hb42ki5a.fsf@firstfloor.org> <4E7F46D0.2060909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7F46D0.2060909@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What are you looking for that perf-script currently does not do?

Hmm can perf-script process raw data from the perf record?

If yes perhaps it is what I want indeed.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab1JGPmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:42:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38352 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1JGPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:42:31 -0400
Date: Fri, 7 Oct 2011 17:42:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for Intel X86
Message-ID: <20111007154229.GE14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com> <1317912555-9559-8-git-send-email-eranian@google.com> <20111006153229.GJ14482@one.firstfloor.org> <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com> <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com> <1317984122.31132.6.camel@twins> <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> just with self-modifying (JIT) code, though the depth of LBR is such that
> this is very unlikely (it must happen in the last 16 branches before the
> PMU interrupt).

Interrupts can make this window arbitary long.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.

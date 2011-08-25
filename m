Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1HYReq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:34:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1HYRen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:34:43 -0400
Subject: Re: [PATCH] perf_event: fix slow and broken cgroup context switch
 code
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ming.m.lin@intel.com,
        Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Date: Thu, 25 Aug 2011 19:34:23 +0200
In-Reply-To: <CABPqkBT_Wf8BLj7U7EDP2jpKUbzCJCbfF1ffzxWn2s-5pd+1og@mail.gmail.com>
References: <20110825135803.GA4697@quad> <1314282021.27911.12.camel@twins>
	 <CABPqkBTnrQRNnAz6Z0Nk+oBczDD4+-NLDtb_o3aMfc11SMe7nw@mail.gmail.com>
	 <1314283321.27911.25.camel@twins>
	 <CABPqkBT_Wf8BLj7U7EDP2jpKUbzCJCbfF1ffzxWn2s-5pd+1og@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314293663.27911.39.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 17:03 +0200, Stephane Eranian wrote:

> I just ran that crash test you pointed out and so far so good. Don't know if
> the crash was systematic, though.


Yeah, it was quite reliable.. but 64ce312618 should really have sorted
the problem.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab2J2Pog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:44:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43026 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597Ab2J2PoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:44:24 -0400
Message-ID: <1351525443.24721.39.camel@twins>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load
 Latency
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Mon, 29 Oct 2012 16:44:03 +0100
In-Reply-To: <CABPqkBT8_nXJhgr4MkbyHrg2wmXr+-DAf_FPBWWnK_GdkEFf_Q@mail.gmail.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	 <1351523752-4215-5-git-send-email-eranian@google.com>
	 <1351525112.24721.36.camel@twins>
	 <CABPqkBT8_nXJhgr4MkbyHrg2wmXr+-DAf_FPBWWnK_GdkEFf_Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:43 +0100, Stephane Eranian wrote:
> You meant fll, instead I think.

Oh, yes, too small font I guess.

> Well, that would work too, but I am trying to factorize the code
> with Precise Store which is a later patch. 

Yeah, just found that, its fine the way it is. Just looked funneh on
first reading.

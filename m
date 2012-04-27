Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763Ab2D0Pt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:49:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37439 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760442Ab2D0PtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:49:25 -0400
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS
 for AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120427151852.GH18810@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
	 <1334398906.2528.49.camel@twins> <20120423095659.GS9747@erda.amd.com>
	 <20120427123434.GF18810@erda.amd.com>
	 <CABPqkBS9FNmHBukzJqGJP1r5iqyLL9gz2g=3jvnt22pDxOdndA@mail.gmail.com>
	 <20120427125410.GG18810@erda.amd.com>
	 <CABPqkBTS2NkFqjVT9HgzPT=TTo9oOc__H9ZDDbXJK7WRpO0Vgg@mail.gmail.com>
	 <20120427151852.GH18810@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Apr 2012 17:30:35 +0200
Message-ID: <1335540635.2463.134.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 17:18 +0200, Robert Richter wrote:
> There is nothing wrong with it. I already implemented that the
> MISC_EXACT flag is supported. But, the flag is basically not used in
> the perf tool and there is no modifier or so to only get a precise
> rip. 

Just because userspace doesn't dtrt doesnt mean its a good idea to wreck
the kernel side of things.

Instead fix the userspace.

I'll simply not take patches that silently drops samples.


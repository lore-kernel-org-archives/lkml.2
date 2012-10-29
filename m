Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143Ab2J2RAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:00:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41540 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071Ab2J2RA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:00:29 -0400
MIME-Version: 1.0
In-Reply-To: <20121029165515.GI2266@tassilo.jf.intel.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-8-git-send-email-eranian@google.com>
	<20121029165515.GI2266@tassilo.jf.intel.com>
Date: Mon, 29 Oct 2012 18:00:28 +0100
Message-ID: <CABPqkBQeo2DiOXDsGEzMwQZWj-_hmAwmFNbLa4_pKiZagb8mTw@mail.gmail.com>
Subject: Re: [Patch v1 07/10] perf tools: add mem access sampling core support
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 5:55 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Mon, Oct 29, 2012 at 04:15:49PM +0100, Stephane Eranian wrote:
>> This patch adds the sorting and histogram support
>> functions to enable profiling of memory accesses.
>
> I hope my weight patches get in soon.
>
> Could you merge your cost with weight then?
>
Those are very similar changes indeed. I need
to investigate whether I can use your directly.

> Otherwise having both cost and weight would be a bit redundant.
>
Yes, we don't want that.

I realized the title of my patch was confusing. Should read: cost support.

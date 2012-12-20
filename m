Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab2LTQNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:13:19 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:60320 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LTQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:13:11 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 11:13:11 EST
MIME-Version: 1.0
In-Reply-To: <20121220160516.GC4526@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
	<20121220160516.GC4526@krava.brq.redhat.com>
Date: Thu, 20 Dec 2012 17:07:21 +0100
Message-ID: <CABPqkBRLQdeYGYxm1YVu9h_MRT_-8EjFt25L7XhPLBgpRy7Z-w@mail.gmail.com>
Subject: Re: [PATCH v4 00/18] perf: add memory access sampling support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's relative to tip.git.
Forgot to mention it in the Changelog.


On Thu, Dec 20, 2012 at 5:05 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Dec 20, 2012 at 04:41:30PM +0100, Stephane Eranian wrote:
>> This patch series had a new feature to the kernel perf_events
>> interface and corresponding user level tool, perf.
>
> hi,
> would you have git tree branch?
>
> thanks,
> jirka

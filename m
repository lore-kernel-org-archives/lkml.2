Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2LTQo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:44:58 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58166 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2LTQow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121220161214.GD4526@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
	<20121220160516.GC4526@krava.brq.redhat.com>
	<CABPqkBRLQdeYGYxm1YVu9h_MRT_-8EjFt25L7XhPLBgpRy7Z-w@mail.gmail.com>
	<20121220161214.GD4526@krava.brq.redhat.com>
Date: Thu, 20 Dec 2012 17:44:51 +0100
Message-ID: <CABPqkBQWhA5orBYgCdFwaGh9Ohiap6=6980_tOoTf3KEPxz1Gg@mail.gmail.com>
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

On Thu, Dec 20, 2012 at 5:12 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Dec 20, 2012 at 05:07:21PM +0100, Stephane Eranian wrote:
>> Hi,
>>
>> It's relative to tip.git.
>> Forgot to mention it in the Changelog.
>
> well I meant git branch I could pull from, so I dont need to do the
> mutt patch store/apply stuff.. no big deal though ;-)
>
Don't have a git tree on kernel.org unfortunately.
So you have to save each one and then use git am < patchN
> jirka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0IUBTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:19:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38695 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0IUBTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=w6YvOMaYc28F4rwjQc0/QA/9al1VmCIToZ3Nn+F5R+K8TweK4rBFez0ncasyb3LYMi
         qi0H5RmwMyOdb+FFAsMPq4Tp2k5hfjSdDNTfyGjS8/PwniUku1WgenajnvUpS4m9wIs4
         fYe5R4hera4pd1cFjgvVeW2PFgkaC42qsBA5o=
MIME-Version: 1.0
In-Reply-To: <4C97F451.5090907@hitachi.com>
References: <AANLkTinJBUxr-GtxxMFsnn_tb-0FS9b1KOe06YiBr5En@mail.gmail.com>
	<4C97F451.5090907@hitachi.com>
Date: Tue, 21 Sep 2010 09:19:13 +0800
Message-ID: <AANLkTinuDWweEt80Kchwzx3B5yeVA5SaFHxJyv9d9pao@mail.gmail.com>
Subject: Re: Is it supported to perf probe data?
From: Luming Yu <luming.yu@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 7:54 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Hi Luming,
>
> (2010/09/20 17:03), Luming Yu wrote:
>> Hi there,
>>
>> I need to analyze accessing pattern to a data in kernel. Wanna to
>> check with you if perf probe can help to get that trace.
>
> Yes, perf probe can add new trace events which can be used
> from perf record/report/trace or ftrace as same as other pre-defined
> trace events. Those new events can record variables as arguments too.
> So you can define new events with accessed data, record it by perf record,
> and see it by perf trace.

e.g. I need to trace accessing to thread_info.flags of a specific task,
would you please show me an example how to do it.

Thanks,
Luming

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212Ab2DLIzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:55:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62896 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2DLIzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <874nspeddl.fsf@sejong.aot.lge.com>
References: <20120410103513.GA9229@quad>
	<874nspeddl.fsf@sejong.aot.lge.com>
Date: Thu, 12 Apr 2012 10:55:48 +0200
Message-ID: <CABPqkBS-MDUJBF6uBxT8heps6Kw=GYVsYHUL_oOWqB-AaiV+nw@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix NO_GTK2 Makefile config error
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, penberg@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 7:19 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> Hi, Stephane
>
> On Tue, 10 Apr 2012 12:35:13 +0200, Stephane Eranian wrote:
>> In case the user specified NO_GTK2 on the make cmdline,
>> compilation would fail with undefined symbol because the
>> Makefile would not set the correct cpp variable:
>> NO_GTK2 vs. NO_GTK2_SUPPORT.
>>
>> This patch renames the variable to the correct name.
>>
>
> I already sent a patch for this. Please see below:
>
>  https://lkml.org/lkml/2012/4/11/459
>
Ok, I was not copied onto your post. And then the fix is buried with others
unrelated changes, it seems. But fine with me. It just needs to be committed
now.


> Thanks,
> Namhyung

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab2GAPGC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 11:06:02 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42051 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GAPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 11:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <87395gyzbf.fsf@sejong.aot.lge.com>
References: <1339944948-3193-1-git-send-email-namhyung@kernel.org>
	<20120618090501.GB28824@gmail.com>
	<87mx3zhekz.fsf@sejong.aot.lge.com>
	<CAMO-S2jPvVZndo3_cM67ZvXXV5y5CKvxe-x6YGfguq3w9mVbAg@mail.gmail.com>
	<CAMO-S2j74+=9QJ40-=3Zj9a2M2wnCC474vsm216GP-BB9OWbsg@mail.gmail.com>
	<87395gyzbf.fsf@sejong.aot.lge.com>
Date: Mon, 2 Jul 2012 00:05:59 +0900
Message-ID: <CAMO-S2g+cuv85XBfTQJTjwp4GcwT2WivLHD9X_gca67TFCBGgQ@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fix an error on perf-bench document
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 10:56 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Wed, 27 Jun 2012 23:28:22 +0900, Hitoshi Mitake wrote:
>> I wrote the simple fix for eliminatng wrong usage of "clock":
>> https://github.com/mitake/linux/commit/b7836d41deff430c16058ca729120dccfa41e74e
>>
>> This patch assumes the change made by the Namhyung's patch. So I'm
>> planning to send this after the Namhyung's patch is applied to tip
>> tree. Or should the patches be unified before applied?
>
> The patch is now in Arnaldo's tree. So you can see it in tip tree soon
> unless something bad happens.
>
> Anyway, looking at your commit (I think it's better just to send it via
> email with mentioning the dependency), it seems only addresses memset
> part but I think memcpy has the same problem, right?

Thanks for your pointing. I had to fix the problem of memcpy too.
I'll send the new patch later.


-- 
Hitoshi Mitake
h.mitake@gmail.com

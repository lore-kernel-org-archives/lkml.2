Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2F1CAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:00:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44208 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2F1B76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:59:58 -0400
X-AuditID: 9c930179-b7cceae000004195-54-4febba999418
From: Namhyung Kim <namhyung@kernel.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix an error on perf-bench document
References: <1339944948-3193-1-git-send-email-namhyung@kernel.org>
	<20120618090501.GB28824@gmail.com> <87mx3zhekz.fsf@sejong.aot.lge.com>
	<CAMO-S2jPvVZndo3_cM67ZvXXV5y5CKvxe-x6YGfguq3w9mVbAg@mail.gmail.com>
	<CAMO-S2j74+=9QJ40-=3Zj9a2M2wnCC474vsm216GP-BB9OWbsg@mail.gmail.com>
Date: Thu, 28 Jun 2012 10:56:04 +0900
In-Reply-To: <CAMO-S2j74+=9QJ40-=3Zj9a2M2wnCC474vsm216GP-BB9OWbsg@mail.gmail.com>
	(Hitoshi Mitake's message of "Wed, 27 Jun 2012 23:28:22 +0900")
Message-ID: <87395gyzbf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 23:28:22 +0900, Hitoshi Mitake wrote:
> I wrote the simple fix for eliminatng wrong usage of "clock":
> https://github.com/mitake/linux/commit/b7836d41deff430c16058ca729120dccfa41e74e
>
> This patch assumes the change made by the Namhyung's patch. So I'm
> planning to send this after the Namhyung's patch is applied to tip
> tree. Or should the patches be unified before applied?

The patch is now in Arnaldo's tree. So you can see it in tip tree soon
unless something bad happens.

Anyway, looking at your commit (I think it's better just to send it via
email with mentioning the dependency), it seems only addresses memset
part but I think memcpy has the same problem, right?

Thanks,
Namhyung

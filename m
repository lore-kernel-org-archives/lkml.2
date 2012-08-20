Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2HTFEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:04:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50442 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2HTFEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:04:40 -0400
MIME-Version: 1.0
In-Reply-To: <87zk5qiar6.fsf@sejong.aot.lge.com>
References: <1345222583-3964-1-git-send-email-namhyung@kernel.org>
	<CAOJsxLEZjxa1ySfVJeD-GJ5_Gi=nJTn40rCSu+PHhXjwn633oQ@mail.gmail.com>
	<878vdajpr6.fsf@sejong.aot.lge.com>
	<874nnyjpir.fsf@sejong.aot.lge.com>
	<87zk5qiar6.fsf@sejong.aot.lge.com>
Date: Mon, 20 Aug 2012 08:04:39 +0300
X-Google-Sender-Auth: eP2NS_AJiI5LMCG3Ps_Z15uD1Nk
Message-ID: <CAOJsxLHGd=FovPNXzekdGy9oRGZkTNPw4dis9YN2LRAK+1giBQ@mail.gmail.com>
Subject: Re: [PATCH] perf ui/gtk: Ensure not to call gtk_main_quit() twice
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 4:59 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Forgot to add the #ifdefery to the below code also. :-/  Anyway, it needs
> to expose gtk specifics to general code with the #ifdef's. So I'd still
> prefer the original patch.

Fair enough.

Acked-by: Pekka Enberg <penberg@kernel.org>

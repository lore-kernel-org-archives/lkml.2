Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0I3LWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:22:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0I3LWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:22:23 -0400
Subject: Re: [PATCH 5/5] perf: Declare hw_perf_{dis,en}able() in
 perf_event.h
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1285583997-1262-6-git-send-email-namhyung@gmail.com>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
	 <1285583997-1262-6-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 13:22:12 +0200
Message-ID: <1285845732.2144.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 19:39 +0900, Namhyung Kim wrote:
> Since they can be defined in arch-specific code declare them in
> perf_event.h and remove following warnings from sparse:
> 
>  kernel/perf_event.c:83:13: warning: symbol 'hw_perf_disable' was not declared. Should it be static?
>  kernel/perf_event.c:84:13: warning: symbol 'hw_perf_enable' was not declared. Should it be static?
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

What tree is this against, those function no longer exist!?

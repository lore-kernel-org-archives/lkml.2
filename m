Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2KCUHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 16:07:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61806 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2KCUHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 16:07:37 -0400
MIME-Version: 1.0
X-Originating-IP: [78.53.219.206]
In-Reply-To: <tip-4592281403e74dc4401d5803ec9948d43bbee7ae@git.kernel.org>
References: <20120829055840.7802.1459.stgit@suzukikp.in.ibm.com>
	<tip-4592281403e74dc4401d5803ec9948d43bbee7ae@git.kernel.org>
Date: Sat, 3 Nov 2012 21:07:36 +0100
Message-ID: <CAMEyesC9H+k-Ypd6F6wLGTWXJzjQ3Va8jQ0ANJzk6gf3FUMOtw@mail.gmail.com>
Subject: Re: [tip:perf/core] perf tools: Remove the node from rblist in strlist__remove
From: Hannes Frederic Sowa <hannes@mailcolloid.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, ananth@in.ibm.com, fweisbec@gmail.com,
        suzuki@in.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 8:04 AM, tip-bot for Suzuki K. Poulose
<suzuki@in.ibm.com> wrote:
> Reported-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>
> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
> Acked-by: David Ahern <dsahern@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/20120829055840.7802.1459.stgit@suzukikp.in.ibm.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Shouldn't this patch go to the -stable queues, too?

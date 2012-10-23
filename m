Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab2JWNst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:48:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57794 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab2JWNsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:48:46 -0400
Subject: Re: [PATCH] perf report: fix broken perf report -n on 32-bit
 systems
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
In-Reply-To: <20121022210025.GA10548@quad>
References: <20121022210025.GA10548@quad>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Oct 2012 22:48:40 +0900
Message-ID: <1351000120.1520.0.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

2012-10-22 (월), 23:00 +0200, Stephane Eranian:
> On 32-bit systems, using perf report -n would yield garbage
> for the Samples column. This is because the hpp code was
> assuming the hist_entry.stat.nr_events was u64 when in
> reality it was u32.
> 
> This patch fixes the problem by defining nr_events
> to be u64. u32 is too small anyway.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung



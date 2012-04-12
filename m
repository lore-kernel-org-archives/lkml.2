Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2DLFTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:19:23 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54072 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab2DLFTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:19:22 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-fb-4f8665d6616b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, penberg@kernel.org
Subject: Re: [PATCH] perf tools: fix NO_GTK2 Makefile config error
References: <20120410103513.GA9229@quad>
Date: Thu, 12 Apr 2012 14:19:02 +0900
In-Reply-To: <20120410103513.GA9229@quad> (Stephane Eranian's message of "Tue,
	10 Apr 2012 12:35:13 +0200")
Message-ID: <874nspeddl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephane

On Tue, 10 Apr 2012 12:35:13 +0200, Stephane Eranian wrote:
> In case the user specified NO_GTK2 on the make cmdline,
> compilation would fail with undefined symbol because the
> Makefile would not set the correct cpp variable:
> NO_GTK2 vs. NO_GTK2_SUPPORT.
>
> This patch renames the variable to the correct name.
> 

I already sent a patch for this. Please see below:

  https://lkml.org/lkml/2012/4/11/459

Thanks,
Namhyung

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2BEHkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 02:40:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47626 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2BEHkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 02:40:09 -0500
MIME-Version: 1.0
In-Reply-To: <1328271538-14502-6-git-send-email-m.szyprowski@samsung.com>
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
	<1328271538-14502-6-git-send-email-m.szyprowski@samsung.com>
Date: Sun, 5 Feb 2012 15:40:08 +0800
Message-ID: <CAJd=RBBsTxV4bM_QEbKaU=uKkFTNgPEK4yTiLjbE0TaEp4KA7w@mail.gmail.com>
Subject: Re: [PATCH 05/15] mm: compaction: export some of the functions
From: Hillf Danton <dhillf@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 8:18 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>
> This commit exports some of the functions from compaction.c file
> outside of it adding their declaration into internal.h header
> file so that other mm related code can use them.
>
> This forced compaction.c to always be compiled (as opposed to being
> compiled only if CONFIG_COMPACTION is defined) but as to avoid
> introducing code that user did not ask for, part of the compaction.c
> is now wrapped in on #ifdef.
>

What if both compaction and CMA are not enabled?

Good weekend
Hillf

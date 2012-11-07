Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2KGIgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:36:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39654 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2KGIgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:36:16 -0500
MIME-Version: 1.0
In-Reply-To: <dd11b4d47ab566931cb943dea34e67c1ce2c3e59.1351530856.git.viresh.kumar@linaro.org>
References: <dd11b4d47ab566931cb943dea34e67c1ce2c3e59.1351530856.git.viresh.kumar@linaro.org>
Date: Wed, 7 Nov 2012 14:06:16 +0530
Message-ID: <CAKohpokakFB6v9P=ocmb3Zx8K6k7qmibzha7+2+boDSBt-TQbQ@mail.gmail.com>
Subject: Re: [PATCH] mtd: map: Fix compilation warning
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dwmw2@infradead.org
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dedekind1@gmail.com, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2012 22:47, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch is an attempt to fix following compilation warning.
>
> In file included from drivers/mtd/chips/cfi_cmdset_0001.c:35:0:
> drivers/mtd/chips/cfi_cmdset_0001.c: In function 'cfi_intelext_write_words':
> include/linux/mtd/map.h:331:11: warning: 'r.x[0]' may be used uninitialized in this function [-Wmaybe-uninitialized]
>
> I could have used uninitialized_var() too, but didn't used it as the final else
> part of map_word_load() is missing. So there is a chance that it might be passed
> uninitialized. Better initialize to zero.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Ping!!

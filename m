Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2IGVW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:22:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48193 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab2IGVWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:22:17 -0400
MIME-Version: 1.0
In-Reply-To: <1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
References: <1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
Date: Fri, 7 Sep 2012 23:22:16 +0200
Message-ID: <CACRpkdb=ie-94D3izWkhKW_EY3KLL-X5buAvMvXrSZmWZMCcLA@mail.gmail.com>
Subject: Re: [PATCH] genalloc: make possible to use a custom allocation algorithm
From: Linus Walleij <linus.walleij@linaro.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ying.huang@intel.com,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 11:16 AM, Benjamin Gaignard
<benjamin.gaignard@linaro.org> wrote:

> From: Benjamin Gaignard <benjamin.gaignard@stericsson.com>
>
> This patch allow to use another algorithm than the default first-fit one.
> For example a custom algorithm could be used to manage alignment requirements.
>
> Add of best-fit algorithm function:
> most of the time best-fit is slower then first-fit but memory fragmentation is lower.
> Random buffer allocation/free tests don't show any arithmetic relation between
> allocation time and fragmentation but best-fit algorithm is sometime able to perform the allocation when first-fit can't.
>
> This new algorithm help to solve fragmentation issues on ESRAM shared by multiple
> hardware IP allocating and freeing dynamically memory region of various sizes.
>
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@stericsson.com>

We really need this to manage our on-chip RAM
(ESRAM) which is a scarce resource, so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

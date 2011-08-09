Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997Ab1HIAvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 20:51:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34162 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1HIAvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 20:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <1312834049-29910-1-git-send-email-per.forlin@linaro.org>
References: <1312834049-29910-1-git-send-email-per.forlin@linaro.org>
Date: Tue, 9 Aug 2011 09:51:06 +0900
Message-ID: <CAC5umyhWr8t7HyQVEn-W-7HSaeESnTLX8okcQNqPO6mYFuWtUg@mail.gmail.com>
Subject: Re: [PATCH --mmotm v5 0/3] Make fault injection available for MMC IO
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: akpm@linux-foundation.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Chris Ball <cjb@laptop.org>, linux-doc@vger.kernel.org,
        linux-mmc@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All three patches look good.
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>

2011/8/9 Per Forlin <per.forlin@linaro.org>:
> This patchset is sent to the mm-tree because it depends on Akinobu's patch
> "fault-injection: add ability to export fault_attr in..."

That patch has already been merged in mainline.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2IQL7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:59:30 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57780 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab2IQL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <1347875423-7970-2-git-send-email-sachin.kamat@linaro.org>
References: <1347875423-7970-1-git-send-email-sachin.kamat@linaro.org>
	<1347875423-7970-2-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 17 Sep 2012 17:29:28 +0530
Message-ID: <CABb+yY3tKfo7TPJ0xO19gOSeFFoTuKEneSd33UsJrTO9qrW7+g@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMA: PL330: Check the pointer returned by kzalloc
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com, patches@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 3:20 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> kzalloc could return NULL. Hence add a check to avoid
> NULL pointer dereference.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch 1 and 2, both
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>

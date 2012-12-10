Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2LJOpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:45:53 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:59950 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2LJOpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:45:51 -0500
MIME-Version: 1.0
In-Reply-To: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 10 Dec 2012 20:08:11 +0530
Message-ID: <CAKohpo=LJS=374dQPmen8VHpW4EtPnxP=+_pdyTNMa80mTgx3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] dmatest: implement two helpers to unmap dma memory
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 17:07, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The unmap_src() and unmap_dst() will be used later as well.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dmatest.c |   27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

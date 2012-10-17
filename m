Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2JQKgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:36:16 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48454 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab2JQKgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:36:14 -0400
MIME-Version: 1.0
In-Reply-To: <1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 17 Oct 2012 16:06:13 +0530
X-Google-Sender-Auth: 264LiU8AFRUE9EwF84HUGH7WqLg
Message-ID: <CAOh2x=k-9avrwL0wOhr=5mgPaqzhUw1YCk50aXJgSeZ13HG-Jg@mail.gmail.com>
Subject: Re: [PATCHv2 3/4] dw_dmac: change {dev_}printk() to corresponding macros
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 4:01 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

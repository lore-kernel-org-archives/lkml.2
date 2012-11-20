Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2KTWEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:04:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54536 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2KTWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:04:29 -0500
MIME-Version: 1.0
In-Reply-To: <1353081126-17995-7-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353081126-17995-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353081126-17995-7-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 20 Nov 2012 23:04:28 +0100
Message-ID: <CACRpkdbsLMEcdRLntKVW9RkL2TWoSie9AnTNFhsqxBbHwDq8=g@mail.gmail.com>
Subject: Re: [PATCHv2 6/6] dma: ste_dma40: reuse is_slave_xfer helper
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 4:52 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> The is_slave_xfer helps to check if the transfer type is slave.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

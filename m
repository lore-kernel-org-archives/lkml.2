Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2IUNzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:55:42 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59575 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2IUNzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:55:40 -0400
MIME-Version: 1.0
In-Reply-To: <1348229149-29040-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 21 Sep 2012 19:25:39 +0530
X-Google-Sender-Auth: hHALjorrgo5jT1GV-ASc4BM6x08
Message-ID: <CAOh2x=mvO71Wu8YWD_fxEoQe57v7QVdoR4mdWf1mp7KYbbOrhw@mail.gmail.com>
Subject: Re: [PATCHv2 2/6] dw_dmac: fill optional encoded parameters in
 register structure
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 5:35 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There is a block of the registers that are optional. However, if enabled they
> contain useful information about the controller hardware configuration. We will
> use this piece of data to autoconfigure the driver.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

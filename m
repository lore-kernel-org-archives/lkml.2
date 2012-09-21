Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2IUN4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:56:51 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55975 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2IUN4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:56:50 -0400
MIME-Version: 1.0
In-Reply-To: <1348229149-29040-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 21 Sep 2012 19:26:48 +0530
X-Google-Sender-Auth: N5idmYPTBykQROxniEcASDyMBzs
Message-ID: <CAOh2x=k+LKT=h26FUPxUaQ0kv-VSLxHc8CakrZLCXVp0NEndBw@mail.gmail.com>
Subject: Re: [PATCHv2 3/6] dw_dmac: get number of channels from hardware if possible
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
> In case the controller has the encoded parameters feature enabled the driver
> will use it to get the number of channels. In the future it will be used for
> the other important parameters as well.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2IUOC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:02:28 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44456 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2IUOC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <1348229149-29040-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348229149-29040-6-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 21 Sep 2012 19:32:26 +0530
X-Google-Sender-Auth: 42atHMduQxN1cvYypT5pjGpPoXY
Message-ID: <CAOh2x=n4ZCsQ1ccqobZF6fz-Kuj_VE-ua5PftAHQkTobA=p+pw@mail.gmail.com>
Subject: Re: [PATCHv2 5/6] dw_dmac: autoconfigure data_width or get it via
 platform data
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
> Not all of the controllers support the 64 bit data width. Make it configurable
> via platform data. The driver will try to get a value from the component
> parameters, otherwise it will use the platform data.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

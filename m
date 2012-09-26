Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab2IZD3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:29:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64131 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2IZD3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:29:48 -0400
MIME-Version: 1.0
In-Reply-To: <1348573156-5032-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <CAOh2x=n4ZCsQ1ccqobZF6fz-Kuj_VE-ua5PftAHQkTobA=p+pw@mail.gmail.com>
	<1348573156-5032-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Sep 2012 08:59:47 +0530
X-Google-Sender-Auth: gyI-QU3Giwml5AmvY-li4XW2ofg
Message-ID: <CAOh2x=mwz95vMTP4DXQ69vR1xE2C3xjTs9Ymp2qcojX6b9-uSw@mail.gmail.com>
Subject: Re: [PATCHv3] dw_dmac: autoconfigure data_width or get it via
 platform data
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 5:09 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Not all of the controllers support the 64 bit data width. Make it configurable
> via platform data. The driver will try to get a value from the component
> parameters, otherwise it will use the platform data.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Since v2:
> - sometimes memory-to-memory test is failed, that's why we need to choose
>   minimum data portion between source and destination limits

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

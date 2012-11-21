Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2KUKGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:06:16 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52266 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KUKGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:06:14 -0500
MIME-Version: 1.0
In-Reply-To: <1353487355-9894-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353487355-9894-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 21 Nov 2012 15:36:13 +0530
Message-ID: <CAKohpo=ff2H5o433QteDT5dfm90=EAe6=-OKPSp-TQz8bk2+HA@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] dw_dmac: store direction in the custom channel structure
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2012 14:12, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Currently the direction value comes from the generic slave configuration
> structure and explicitly as a preparation function parameter. The first one is
> kinda obsoleted. Thus, we have to store the value passed to the preparation
> function somewhere in our structures to be able to use it later. The best
> candidate to provide the storage is a custom channel structure. Until now we
> still keep and check the direction field of the slave config structure as well.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Vinod, these patches look fine to me. Please apply them for 3.8.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2KTOK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:10:56 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:46525 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KTOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:10:52 -0500
MIME-Version: 1.0
In-Reply-To: <1353418726-7879-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353418726-7879-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353418726-7879-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 20 Nov 2012 19:40:52 +0530
Message-ID: <CAKohponHvWaPZ2iLsqgi2-cn76OxjuLJcRY40bWvx1EFUs6PcQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: make usage of dw_dma_slave optional
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 19:08, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The driver requires a custom slave configuration to be present to be able to
> make the slave transfers. Nevertheless, in some cases we need only the request
> line as an additional information to the generic slave configuration.  The
> request line is provided by slave_id parameter of the dma_slave_config
> structure. That's why the custom slave configuration could be optional for such
> cases.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

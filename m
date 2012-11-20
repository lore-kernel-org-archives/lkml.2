Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2KTWD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:03:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45321 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2KTWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <1353081126-17995-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353081126-17995-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353081126-17995-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 20 Nov 2012 23:03:56 +0100
Message-ID: <CACRpkdYB9ZwofVLAzkG4=H+68ODruw=7=Rj-QSPeDuwGRyp9rg@mail.gmail.com>
Subject: Re: [PATCHv2 1/6] dmaengine: introduce is_slave_xfer function
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 4:52 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> This function helps to distinguish the slave type of transfer by checking the
> direction parameter.

Looks like a good idea.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

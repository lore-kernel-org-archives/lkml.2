Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0LMEI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:08:58 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:32847 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235Ab0LMEI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:08:57 -0500
Date: Mon, 13 Dec 2010 09:05:37 +0530
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Sundar R IYER <sundar.iyer@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] mfd: Convert SMTPE driver to new irq_ APIs
Message-ID: <20101213033537.GB32116@bnru06.bnr.st.com>
References: <1292155268-18246-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1292155268-18246-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 13:01:08 +0100, Mark Brown wrote:
> The genirq core is being updated to supply struct irq_data to irq_chip
> operations rather than an irq number. Update the SMTPE driver to the new
> APIs.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>

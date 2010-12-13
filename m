Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0LMD5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:57:19 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:38077 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab0LMD5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:57:17 -0500
X-Greylist: delayed 1422 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 22:57:16 EST
Date: Mon, 13 Dec 2010 09:03:05 +0530
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] mfd: Conver tc35892 to new irq_ APIs
Message-ID: <20101213033304.GA32116@bnru06.bnr.st.com>
References: <1292156769-20718-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1292156769-20718-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 13:26:09 +0100, Mark Brown wrote:
> The genirq core is being converted to pass struct irq_data to irq_chip
> operations rather than an IRQ number. Update the tc35892 driver to the
> new APIs.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>

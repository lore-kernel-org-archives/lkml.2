Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab0LNLMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:12:01 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:35208 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757571Ab0LNLMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:12:00 -0500
Message-ID: <4D0750D6.5030501@stericsson.com>
Date: Tue, 14 Dec 2010 12:11:18 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] mfd: Convert AB8500 to new irq_ methods
References: <1292086533-7381-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1292086533-7381-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2010 05:55 PM, Mark Brown wrote:
> The genirq core is being converted to supply struct irq_data to chips
> rather than the interrupt number.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>

Yours,
Mattias Wallin

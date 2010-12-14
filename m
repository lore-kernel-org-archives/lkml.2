Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0LNLK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:10:28 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:53108 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab0LNLK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:10:27 -0500
Message-ID: <4D07506C.2020007@stericsson.com>
Date: Tue, 14 Dec 2010 12:09:32 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] mfd: Convert AB3500 to new irq_ APIs
References: <1292086499-7277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1292086499-7277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2010 05:54 PM, Mark Brown wrote:
> The genirq core is being updated to pass struct irq_data rather than irq
> numbers into chip drivers. As part of the update assignments to NULL for
> unused operations are removed, these are not needed and the genirq docs
> should be good enough.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>

Yours,
Mattias Wallin

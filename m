Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1FFHCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:02:15 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60675 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108Ab1FFHCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:02:13 -0400
Message-ID: <4DEC7B6D.6060901@ti.com>
Date: Mon, 06 Jun 2011 12:32:05 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: omap4: gpio: fix setting IRQWAKEN bits
References: <1307214239-16316-1-git-send-email-ccross@android.com>
In-Reply-To: <1307214239-16316-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2011 12:33 AM, Colin Cross wrote:
> Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
> causing only the last bit set to take effect, resulting in lost
> wakeups when the GPIO controller is in idle.
>
> Replace direct writes to IRQWAKEN with writes to SETWKUENA and
> CLEARWKUEN.
>
> Signed-off-by: Colin Cross<ccross@android.com>

Looks good. This needs to be fixed on top of the clean-up
branch where GPIO movemnt to driver/gpio/* happening.

For this change,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>	


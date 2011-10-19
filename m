Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1JSHd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:33:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50346 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1JSHd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:33:27 -0400
Date: Wed, 19 Oct 2011 03:33:24 -0400 (EDT)
Message-Id: <20111019.033324.1233460304204609569.davem@davemloft.net>
To: cloud.ren@Atheros.com
Cc: Luis.Rodriguez@Atheros.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319009213-20627-1-git-send-email-cloud.ren@atheros.com>
References: <1319009213-20627-1-git-send-email-cloud.ren@atheros.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 00:33:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <cloud.ren@Atheros.com>
Date: Wed, 19 Oct 2011 15:26:53 +0800

> +#define HW_PRINT(_klv, _fmt, _args...) \
> +	if (ALX_HW_MSG_LV_##_klv || ALX_HW_MSG_LV_ALL) {\
> +		printk(KERN_##_klv ALX_HW_MSG_PFX_NAME "%s: " _fmt, \
> +			__func__, ## _args); \
> +	}

Do not create your own network driver debugging facilities and macros
for logging messages, we have rich debugging and logging level
interfaces that network drivers can use exactly for this purpose.

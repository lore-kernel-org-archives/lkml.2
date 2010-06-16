Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0FPMnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 08:43:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:54988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0FPMnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 08:43:22 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] hmc6352: Add driver for the HMC6352 compass
Date: Wed, 16 Jun 2010 14:43:45 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc2-0.1-default+; KDE/4.3.5; x86_64; ; )
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100616121534.26294.12540.stgit@localhost.localdomain>
In-Reply-To: <20100616121534.26294.12540.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006161443.45375.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 16. Juni 2010 14:16:14 schrieb Alan Cox:
> +       msleep(10); /* sending 0x41 cmd we need to wait for 7-10 milli seconds */
> +       ret = i2c_transfer(client->adapter, msg1, 1);
> +       if (ret != 1) {
> +               dev_warn(dev, "i2c read data cmd failed\n");
> +               return ret;
> +       }
> +       ret_val = i2c_data[0];
> +       ret_val = ((ret_val << 8) | i2c_data[1]);

Please use the correct macro for this conversion.

	Regards
		Oliver

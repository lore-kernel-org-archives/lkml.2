Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0INLxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 07:53:13 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:9170 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab0INLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 07:53:10 -0400
Date: Tue, 14 Sep 2010 13:52:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH v2 6/7] hwmon: (lm90) Add support for additional
 features of max6659
Message-ID: <20100914135253.6f218514@hyperion.delvare>
In-Reply-To: <1284038750-8833-7-git-send-email-guenter.roeck@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
	<1284038750-8833-7-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Thu, 9 Sep 2010 06:25:49 -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  Documentation/hwmon/lm90 |   13 ++++++-----
>  drivers/hwmon/lm90.c     |   51 ++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 45 insertions(+), 19 deletions(-)
> (...)
> @@ -94,7 +94,7 @@ static const unsigned short normal_i2c[] = {
>  	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
>  
>  enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
> -	w83l771 };
> +	w83l771, max6659 };

As the numbers are internal only, it might make sense to group max6657
and max6659 together for better readability.

No other comment, other than the patch ordering (or merging) issue
already pointed out in patch 5/7.

-- 
Jean Delvare

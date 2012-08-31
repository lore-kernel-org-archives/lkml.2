Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2HaOhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:37:35 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:40186 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2HaOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:37:34 -0400
Date: Fri, 31 Aug 2012 16:37:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: add Maxim MAX197 support
Message-ID: <20120831163718.38144c01@endymion.delvare>
In-Reply-To: <20120830210959.GA11153@roeck-us.net>
References: <1346351995-9038-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20120830210959.GA11153@roeck-us.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2012 14:09:59 -0700, Guenter Roeck wrote:
> I have the solution for the platform driver.
> 
> enum chips { max197, max199 };
> 
> [ ... ]
> 
> static struct platform_device_id max197_driver_ids[] = {
>         {
> 		.name = "max197",
> 		.driver_data = max197,
> 	}, {
> 		.name = "max199",
> 		.driver_data = max199,
> 	}
> };
> MODULE_DEVICE_TABLE(platform, max197_driver_ids);

Wow, I thought this did not exist and this made me rumble a number of
times, and now I see this was finally introduced over 3 years ago.
Cool! And spi has it too now, wonderful world :)

-- 
Jean Delvare

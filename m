Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2HaQHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:07:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50273 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2HaQHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:07:36 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 31 Aug 2012 09:07:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: add Maxim MAX197 support
Message-ID: <20120831160750.GC5756@roeck-us.net>
References: <1346351995-9038-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20120830210959.GA11153@roeck-us.net>
 <20120831163718.38144c01@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831163718.38144c01@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 04:37:18PM +0200, Jean Delvare wrote:
> On Thu, 30 Aug 2012 14:09:59 -0700, Guenter Roeck wrote:
> > I have the solution for the platform driver.
> > 
> > enum chips { max197, max199 };
> > 
> > [ ... ]
> > 
> > static struct platform_device_id max197_driver_ids[] = {
> >         {
> > 		.name = "max197",
> > 		.driver_data = max197,
> > 	}, {
> > 		.name = "max199",
> > 		.driver_data = max199,
> > 	}
> > };
> > MODULE_DEVICE_TABLE(platform, max197_driver_ids);
> 
> Wow, I thought this did not exist and this made me rumble a number of
> times, and now I see this was finally introduced over 3 years ago.
> Cool! And spi has it too now, wonderful world :)
> 
Same here ... and now I feel a bit embarassed that I didn't know :)

Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2HaRiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:38:22 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:51120 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2HaRiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:38:20 -0400
Date: Fri, 31 Aug 2012 13:38:13 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Message-ID: <645218150.271690.1346434693393.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <20120831160750.GC5756@roeck-us.net>
Subject: Re: [PATCH] hwmon: add Maxim MAX197 support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, good to know that it exists. Thanks for spotting this and applying the patches!

Regards,
Vivien

----- Mail original -----
De: "Guenter Roeck" <linux@roeck-us.net>
À: "Jean Delvare" <khali@linux-fr.org>
Cc: "Vivien Didelot" <vivien.didelot@savoirfairelinux.com>, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Envoyé: Vendredi 31 Août 2012 12:07:50
Objet: Re: [PATCH] hwmon: add Maxim MAX197 support

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

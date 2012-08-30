Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2H3VWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:22:06 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:38091 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2H3VWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:22:04 -0400
Date: Thu, 30 Aug 2012 17:22:02 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Message-ID: <378258773.403150.1346361722651.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <20120830211444.GA11181@roeck-us.net>
Subject: Re: [PATCH] hwmon: add Maxim MAX197 support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess we're too fast!

I've just seen your reply, this is much cleaner, indeed.
I'll update the max197 driver, and fix the sht15 driver as soon as I can.

Thanks,
Vivien

----- Mail original -----
De: "Guenter Roeck" <linux@roeck-us.net>
À: "Vivien Didelot" <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, "Jean Delvare" <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Envoyé: Jeudi 30 Août 2012 17:14:44
Objet: Re: [PATCH] hwmon: add Maxim MAX197 support

On Thu, Aug 30, 2012 at 05:10:32PM -0400, Vivien Didelot wrote:
> Hi Guenter,
> 
> Thanks for your detailed comments. I'll send a new version soon.
> 
> About the following comment, I agree with you. However as there is no convention for this case, for now I would prefer to stick with the model as seen in drivers such as sht15.
> 
Actually, there is a convention, and it is much cleaner than using
multiple platform driver instances. I sent you a separate e-mail a
minute ago, describing how it works.

We should actually fix the sht15 driver as well to use the same approach.

Thanks,
Guenter

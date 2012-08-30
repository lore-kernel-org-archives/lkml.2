Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2H3VO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:14:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63111 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab2H3VOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:32 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 Aug 2012 14:14:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: add Maxim MAX197 support
Message-ID: <20120830211444.GA11181@roeck-us.net>
References: <20120830201019.GA3875@roeck-us.net>
 <1040994502.402858.1346361031972.JavaMail.root@mail.savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1040994502.402858.1346361031972.JavaMail.root@mail.savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

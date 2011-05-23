Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1EWPOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:14:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1EWPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:14:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Mon, 23 May 2011 17:13:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105112203.54838.arnd@arndb.de> <20110522202129.GE18610@sortiz-mobl>
In-Reply-To: <20110522202129.GE18610@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231713.49067.arnd@arndb.de>
X-Provags-ID: V02:K0:E872/9xqeKdbVt+QkwC4BZqZZDnDRgjt1NsgZnrJY6k
 6exCPBxMjuSQa/RrZnDJXPo2yiYoWdE1rQ50i5z/uJ6qrXhfQY
 6/uogx5IvPCy+Qhk2VrMIAPioRM04IvHCflebi0oeRbaa0f4yy
 X0GyqQFFF8T5WQCnErJhmzRjwQ2vjboJAI7agPmnKK7nCCUSZz
 zVzEKibxyhlToDSqaqarg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Sunday 22 May 2011, Samuel Ortiz wrote:
> On Wed, May 11, 2011 at 10:03:54PM +0200, Arnd Bergmann wrote:
> > On Wednesday 11 May 2011, Subhasish Ghosh wrote:
> > We had a little discussion at the Linaro Developer Summit about your
> > driver and mfd drivers in general. There was a general feeling among
> > some people (including me) that by the point you dynamically create
> > the subdevices, MFD is probably not the right abstraction any more,
> > as it does not provide any service that you need.
> I agree it's not what it's been designed for.
> 
> 
> > Instead, maybe you can simply call platform_device_register
> > at that stage to create the children and not use MFD at all.
> The MFD APIs are slightly easier to use though, imho.
> 
> 
> > Samuel, can you comment on this as well? Do you still see pruss
> > as an MFD driver when the uses are completely dynamic and determined
> > by the firmware loaded into it?
> Even though that is definitely not a typical MFD use case, I wouldn't object
> strongly against it. Right now mfd is probably the least worst choice for this
> kind of drivers, which still doesn't make it an ideal situation.

Thanks for your input! When you say that MFD APIs are easier to use than
platform_device APIs, is that something we should fix with platform devices
to make them easier to use?

	Arnd

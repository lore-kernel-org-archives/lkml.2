Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2H3LIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:08:13 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:57813 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032Ab2H3LIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:08:12 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Date: Thu, 30 Aug 2012 13:08:09 +0200
Message-ID: <6208908.ZjG7eB9lJn@ws-stein>
User-Agent: KMail/4.8.5 (Linux/3.4.9-gentoo; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20120830171915.36b6d10b@feng-i7>
References: <4401854.hVfHzgeqjT@ws-stein> <4378288.tkkLiQ5MQ7@ws-stein> <20120830171915.36b6d10b@feng-i7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2012 17:19:15, Feng Tang wrote:
> > IMO the i2c_register_board_info only works in quite static setups. Especially with I2C-Busses attached to hotplugable PCI devices this way doesn't work reliable any more.
> > The device come and go dynamically so you can't assume fixed mapping.
> 
> Can you specify the hotplugable?
> 1. A hotplugable i2c bus controller (say i2c_eg20t) with all fixed i2c
>  devices connecting to it
> 2. i2c bus controller is fixed, while the i2c devices will be dynamically
>  connected to it.
> 3. Both the bus controller and devices are dynamically hotplugged

I had scenario 1 in mind, but with more than 1 bus controller (say 2x i2c_eg20t). How can you set a fixed numbering if there are more controllers, each with maybe more than 1 bus?
Anyway, how can you provide a static bus numbering if there are more than one driver or more than one device per driver if the devices are hotplugable?

Best regards,
Alexander


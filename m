Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1LVQOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:14:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51789 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1LVQOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:14:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111220104240.GA31842@legolas.emea.dhcp.ti.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
	<1324341747-5922-9-git-send-email-felipe.contreras@gmail.com>
	<20111220104240.GA31842@legolas.emea.dhcp.ti.com>
Date: Thu, 22 Dec 2011 18:14:34 +0200
Message-ID: <CAMP44s2vJfG-Co+eF5jgt2cb3vd__=_M_HLALbVM5_kCArwxBQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] usb: gadget: remove useless dependency in config
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vladimir Zapolskiy <vz@mleia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/20 Felipe Balbi <balbi@ti.com>:
> On Tue, Dec 20, 2011 at 02:42:25AM +0200, Felipe Contreras wrote:
>> USB_OTG_UTILS is already selected by NOP_USB_XCEIV.
>
> did you mean it's selected by the isp1301 driver ?

No.

config NOP_USB_XCEIV
	tristate "NOP USB Transceiver Driver"
	select USB_OTG_UTILS

-- 
Felipe Contreras

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2A0QWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:22:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56091 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab2A0QWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:22:07 -0500
From: "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: musb: make modules behave better
Thread-Topic: [PATCH] usb: musb: make modules behave better
Thread-Index: AQHM3Be3UJL1bRUSa0CModb5/tb3WJYgMEAg
Date: Fri, 27 Jan 2012 16:21:58 +0000
Message-ID: <B6A220404B6BFC4BBD2AB91C54D39DF43176A805@DBDE01.ent.ti.com>
References: <1327574749-18552-1-git-send-email-balbi@ti.com>
In-Reply-To: <1327574749-18552-1-git-send-email-balbi@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.84]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 26, 2012 at 16:15:49, Balbi, Felipe wrote:
> There's really no point in doing all that
> initcall trickery when we can safely let
> udev handle module probing for us.
> 
> Remove all of that trickery, by moving everybody
> to module_init() and making proper use of
> platform_device_register() rather than
> platform_device_probe().
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> 

Tested on DM644x EVM.

Tested-by: Rajashekhara, Sudhakar <sudhakar.raj@ti.com>

Thanks,
Sudhakar


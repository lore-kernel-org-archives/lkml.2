Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767621Ab2KOLpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:45:13 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:50680 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993197Ab2KOLpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:45:10 -0500
Message-ID: <50A4D5BB.6010301@ahsoftware.de>
Date: Thu, 15 Nov 2012 12:44:59 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Till Harbaum <till@harbaum.org>
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de> <1352920954.19432.2.camel@Nokia-N900> <50A42A91.2000202@ahsoftware.de> <1639554.ZUOmHr6Yka@lxtiha>
In-Reply-To: <1639554.ZUOmHr6Yka@lxtiha>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 15.11.2012 12:04, schrieb Till Harbaum:

> There's actually one thing you can do: You device doesn't seem to expose
> the i2c bus, anyway. What you have is an rtc connected via usb. So why not
> move all the i2c intelligence into the device? Do pure usb-rtc's exist?
> Could you perhaps even make your device compatible to one of these?
> Then a driver for this would imho have good chances to find their way into
> the kernel.

Sorry, but I'm satisfied with what I've done and I didn't do it just to 
get "something" into the kernel. I don't need my patches to become part 
of in the kernel, I can handle them by myself. And my free resources to 
submit patches just became exhausted (again). Maybe in some weeks or 
month ..., I don't know.

Regards,

Alexander

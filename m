Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2KMXmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:42:11 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:47265 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2KMXmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:42:09 -0500
Message-ID: <50A2DAC6.6000105@ahsoftware.de>
Date: Wed, 14 Nov 2012 00:41:58 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH] i2c: i2c-tiny-usb: Add parameter for optional i2c-devices.
References: <50A2AC28.7050304@ahsoftware.de> <1352839940-7559-1-git-send-email-holler@ahsoftware.de> <20121113224251.20b52f34@pyramind.ukuu.org.uk>
In-Reply-To: <20121113224251.20b52f34@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.11.2012 23:42, schrieb Alan Cox:
> On Tue, 13 Nov 2012 21:52:20 +0100
> Alexander Holler <holler@ahsoftware.de> wrote:
>
>> Make it possible to define i2c-devices at the kernel command line
>> or as a module parameter.
>>
>> Format is devname1@addr1,devname2@addr2,...
>
> Why not do this with your initrd, you can deal with your rtc
> before mounting the real root fs.

I almost never use an initrd. Most of the time it isn't necessary and is 
just a waste of time to build, maintain and use it.

Thanks to git, I even find it it easier to maintain my own set of 
patches for the kernel (which I do since several years) and I find it 
easier to explain such others too, than to explain someone about how to 
build, maintain and use an initrd.

Regards,

Alexander

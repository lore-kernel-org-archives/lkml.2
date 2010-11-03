Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0KCK4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:56:25 -0400
Received: from mognix.dark-green.com ([88.116.226.179]:63485 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab0KCK4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:56:22 -0400
MIME-Version: 1.0
Date: Wed, 03 Nov 2010 11:56:20 +0100
From: gimli <gimli@dark-green.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] MacBookAir3,1(3,2) touchpad ( bcm5974 ) support
In-Reply-To: <4CD041AE.80009@euromail.se>
References: <4f8c3332b3e4cdec23a7caafc534a395@mognix.dark-green.com> <4CD041AE.80009@euromail.se>
Message-ID: <ec999a7b97caaeccf538fb50af68067c@mognix.dark-green.com>
User-Agent: RoundCube Webmail/0.2.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Nov 2010 17:51:58 +0100, Henrik Rydberg <rydberg@euromail.se>
wrote:
> On 11/02/2010 08:18 AM, gimli wrote:
> 
>> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
>> bcm5974 driver.
>> 
>> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
> 
> 
> Thanks for your patches. Do the usb message packet lengths of these new
> device
> ids differ in any respect from the old ones? What is the difference
between
> the
> two sets of ids? Physical size? Are the devices really exactly the same?
> 
> Any additional information you can provide to shed light on these
questions
> would be greatly appreciated. My concern is that there might be more
things
> that
> need to be changed for these devices.

What i did was asuming the touchpad works similiar to the WELLSPRING3 ones.
So i took the names from the Apple kext's and used the values from the
WELLSPRING3.
If i can with any debug output let me know how to make it and i'll more
than happy
to send it.
As far as i see only the Size on the new ones differ. 

lg

Edgar (gimli) Hucek

> Thanks,
> Henrik
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

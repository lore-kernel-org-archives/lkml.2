Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0ESVro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:47:44 -0400
Received: from mail.catechsoftworks.biz ([80.123.216.188]:51316 "EHLO
	mail.catechsoftworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0ESVrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:47:42 -0400
Message-ID: <4BF45C6E.4040507@vmars.tuwien.ac.at>
Date: Wed, 19 May 2010 23:47:26 +0200
From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
References: <4BE2D05C.1090708@vmars.tuwien.ac.at> <20100519120642.a84ba8b5.akpm@linux-foundation.org>
In-Reply-To: <20100519120642.a84ba8b5.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------000804080906000905070706"
X-SA-Exim-Connect-IP: 192.168.0.36
X-SA-Exim-Mail-From: froemel@vmars.tuwien.ac.at
Subject: Re: btusb patch, add_apple_MacBookPro62
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on mail.catechsoftworks.biz)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000804080906000905070706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/19/2010 09:06 PM, Andrew Morton wrote:
> [...]
>    
>> Hello Marcel,
>>
>> the Apple MBP model 6.2 (and maybe other recent MBPs) use an Apple
>> branded BCM2046 USB bluetooth device that works well [1] with your
>> generic driver.
>> The attached patch just adds the vendor and device id - please apply.
>>
>> Cheers,
>>    -bf
>>
>> [1] http://ubuntuforums.org/showthread.php?t=1469437
>>
>>      
> Please send us a Signed-off-by: for this patch, as explained in
> Documentation/SubmittingPatches, thanks.
>    
Sorry - there you go:

Signed-off-by: Bernhard Froemel <froemel@vmars.tuwien.ac.at>


Attached the patch one more time,
   -bf

--------------000804080906000905070706
Content-Type: text/x-patch;
 name="btusb_add_apple_MacBookPro62.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btusb_add_apple_MacBookPro62.patch"

--- linux/drivers/bluetooth/btusb.c	2010-05-06 15:56:18.228630685 +0200
+++ linux_p/drivers/bluetooth/btusb.c	2010-05-02 11:03:55.955362854 +0200
@@ -75,6 +75,9 @@
 	/* Canyon CN-BTU1 with HID interfaces */
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
+	/* Apple MacBookPro6 BT device */
+	{ USB_DEVICE(0x05ac, 0x8218) },
+
 	{ }	/* Terminating entry */
 };
 

--------------000804080906000905070706--

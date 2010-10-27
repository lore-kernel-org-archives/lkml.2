Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0J0OR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:17:29 -0400
Received: from asmtpout027.mac.com ([17.148.16.102]:62456 "EHLO
	asmtpout027.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0J0OR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:17:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-27_07:2010-10-27,2010-10-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010270056
Subject: Re: kernel BUG at drivers/mmc/core/sdio_io.c:28!
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <AANLkTimvER2Qjpphj+io-qh9mRfDQJ1=goARH3zDLpeJ@mail.gmail.com>
Date: Wed, 27 Oct 2010 18:16:45 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <60722BDE-68CB-47B7-856E-6986D760FE42@mac.com>
References: <652BFE86-3BFE-4E21-88BA-004CA7140D18@mac.com>
 <AANLkTimvER2Qjpphj+io-qh9mRfDQJ1=goARH3zDLpeJ@mail.gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Oct 27, 2010, at 6:05 PM, Ohad Ben-Cohen wrote:

> You actually seem to have two problems here:
> 1. Your SDIO driver's probe function isn't called
> 2. Your WLAN driver is using the SDIO API without having a valid SDIO function
> 
> Ignoring the 2nd issue for now, you most probably have an integration
> problem.  Is the chip powered up correctly ?

Yes, I checked the VBAT, and VIO and WLAN Power Enable signals.

> is it mmc rescanned after it is powered up ?

I'm not sure about this. How can I check this? Could you point me to a code fragment?

> are you using the correct mmc controller ?

Yes, MMC2, as per the schematics.

> have you configured your mmc lines correctly (board muxing) ? etc..

Yes, I've setup the mux settings correctly.

> Maybe you want to checkout the mainline wl1271 driver using Luca's
> Beagle board patches :)

Ok, will try it once again. 

Best regards,

Elvis

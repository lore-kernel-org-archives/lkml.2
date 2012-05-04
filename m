Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab2EDQ1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:27:05 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:59260 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182Ab2EDQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:27:03 -0400
From: Alexander Stein <a.stein@systec-electronic.com>
To: Preston Fick <pffick@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Date: Fri, 04 May 2012 18:26:58 +0200
Message-ID: <1436626.86ImxHLlqB@ws-stein>
User-Agent: KMail/4.8.0 (Linux/3.2.12-gentoo; KDE/4.8.1; x86_64; ; )
In-Reply-To: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 30. April 2012, 15:27:17 schrieb Preston Fick:
> This fix contains several changes that allow toggling of GPIO on CP210x
> devices that support it. Changes include:
> * Added in part number support, necessary to see if the connected device
> supports the GPIO functionality
> * Added two IOCTLs and ioctl function to allow GET/SET of GPIO
> * Added in new #defines for partnum support, new USB requests
> * Changed "Config request types" section to contain more correct definitions
> for request recipient
> 
> Signed-off-by: Preston Fick <preston.fick@silabs.com>

Do you actually need to create new ioctls? You also could support gpiolib and 
create a gpiochip for that.

just my 2 cents,
Alexander


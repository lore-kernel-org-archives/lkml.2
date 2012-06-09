Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2FIPb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 11:31:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51034 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751500Ab2FIPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 11:31:55 -0400
Date: Sat, 9 Jun 2012 11:31:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Namjae Jeon <linkinjeon@gmail.com>
cc: James.Bottomley@HansenPartnership.com, <gregkh@linuxfoundation.org>,
        <mdharm-usb@one-eyed-alien.net>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 3/4] usb: storage: update usb devices for write cache
 quirk in quirk list.
In-Reply-To: <1339243754-2150-1-git-send-email-linkinjeon@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206091131040.11334-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2012, Namjae Jeon wrote:

> Update information of Segate Portable HDD and WD My Passport HDD in
> quirk list.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  drivers/usb/storage/unusual_devs.h |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index 1719886..1d895f4 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -2025,6 +2025,16 @@ UNUSUAL_DEV( 0xed10, 0x7636, 0x0001, 0x0001,
>  		"Digital MP3 Audio Player",
>  		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
>  
> +UNUSUAL_DEV(0x1058, 0x070A, 0x0000, 0x9999,
> +		"Western Digital",
> +		"My Passport HDD",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
> +
> +UNUSUAL_DEV(0x0BC2, 0x2300, 0x0000, 0x9999,
> +		"Seagate",
> +		"Portable HDD",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
> +

Entries must be sorted by Vendor ID and then Product ID.  Please put 
your new entries in the correct spot.

Alan Stern


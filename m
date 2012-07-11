Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2GKRYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:24:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34703 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2GKRYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:24:06 -0400
MIME-Version: 1.0
In-Reply-To: <1341716749-6733-1-git-send-email-linkinjeon@gmail.com>
References: <1341716749-6733-1-git-send-email-linkinjeon@gmail.com>
Date: Wed, 11 Jul 2012 22:54:04 +0530
Message-ID: <CADDb1s3TM23FjoDdJCcDkPBXwhvw9M1KqPAPhKMTQRyGnF2HLg@mail.gmail.com>
Subject: Re: [PATCH RESEND 3/3] usb: storage: update usb devices for write
 cache quirk in quirk list.
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Jej B <James.Bottomley@hansenpartnership.com>
Cc: gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net,
        stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org,
        akpm@linux-foundation.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,
Please have a look at the patchset and share your opinion.
If there is anything more to it - please let us know.

Thanks & Regards,
Amit Sahrawat


On Sun, Jul 8, 2012 at 8:35 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> Update information of Seagate Portable HDD and WD My Passport HDD in
> quirk list.
>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/storage/unusual_devs.h |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index 1719886..62a31be 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -1267,6 +1267,12 @@ UNUSUAL_DEV( 0x0af0, 0xd357, 0x0000, 0x0000,
>                 USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>                 0 ),
>
> +/* Reported by Namjae Jeon <namjae.jeon@samsung.com> */
> +UNUSUAL_DEV(0x0bc2, 0x2300, 0x0000, 0x9999,
> +               "Seagate",
> +               "Portable HDD",
> +               USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
> +
>  /* Reported by Ben Efros <ben@pc-doctor.com> */
>  UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0000,
>                 "Seagate",
> @@ -1468,6 +1474,12 @@ UNUSUAL_DEV(  0x1058, 0x0704, 0x0000, 0x9999,
>                 USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>                 US_FL_SANE_SENSE),
>
> +/* Reported by Namjae Jeon <namjae.jeon@samsung.com> */
> +UNUSUAL_DEV(0x1058, 0x070a, 0x0000, 0x9999,
> +               "Western Digital",
> +               "My Passport HDD",
> +               USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
> +
>  /* Reported by Fabio Venturi <f.venturi@tdnet.it>
>   * The device reports a vendor-specific bDeviceClass.
>   */
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

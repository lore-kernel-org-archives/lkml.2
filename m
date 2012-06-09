Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2FILQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 07:16:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64241 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884Ab2FILQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 07:16:16 -0400
Message-ID: <4FD3305E.1040803@mvista.com>
Date: Sat, 09 Jun 2012 15:15:42 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 3/4] usb: storage: update usb devices for write cache
 quirk in quirk list.
References: <1339211540-10315-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1339211540-10315-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-06-2012 7:12, Namjae Jeon wrote:

> Update information of Segate Portable HDD and WD My Passport HDD in
> quirk list.

> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
> ---
>   drivers/usb/storage/unusual_devs.h |   10 ++++++++++
>   1 file changed, 10 insertions(+)

> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index 1719886..1d895f4 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -2025,6 +2025,16 @@ UNUSUAL_DEV( 0xed10, 0x7636, 0x0001, 0x0001,
>   		"Digital MP3 Audio Player",
>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
>
> +UNUSUAL_DEV(0x1058, 0x070A, 0x0000, 0x9999,
> +		"Westron Digital",

    Maybe "Western"? :-)

> +		"My Passport HDD",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),

WBR, Sergei

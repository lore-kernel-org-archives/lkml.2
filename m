Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1BVPYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:24:03 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59944 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1BVPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=su3TVJIrU6gGYum57Xb35oyG2678jmuF0yhSdA8Q81TTVAgGptwFParPkMmCCo1997
         MCJDNcuoloHEOmtBXxJecLSX5YueDgzRKwC06px8rEkfkrLhw294gnq6aSVzp1O5ZsNX
         MK+ptrBHXYjTS5oa8oY7eyjh3kYTYGvu/RFqg=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Shahar Havivi <shaharh@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH-v2] Added support for usb ethernet (0x0fe6, 0x9700)
References: <20110222144110.GG2122@redhat.com>
Date: Tue, 22 Feb 2011 16:23:44 +0100
In-Reply-To: <20110222144110.GG2122@redhat.com> (Shahar Havivi's message of
	"Tue, 22 Feb 2011 16:41:11 +0200")
Message-ID: <87hbbwqein.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Shahar" == Shahar Havivi <shaharh@redhat.com> writes:

 Shahar> The device is very similar to (0x0fe6, 0x8101),
 Shahar> And works well with dm9601 driver.

 Shahar> Signed-off-by: Shahar Havivi <shaharh@redhat.com>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

 Shahar> ---
 Shahar> v2:
 Shahar> Fix Peter Korsgaard comments:
 Shahar> got rid of empty line,
 Shahar> move after the 0x8101 device
 Shahar> ---
 Shahar>  drivers/net/usb/dm9601.c |    4 ++++
 Shahar>  1 files changed, 4 insertions(+), 0 deletions(-)

 Shahar> diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
 Shahar> index 02b622e..5002f5b 100644
 Shahar> --- a/drivers/net/usb/dm9601.c
 Shahar> +++ b/drivers/net/usb/dm9601.c
 Shahar> @@ -651,6 +651,10 @@ static const struct usb_device_id products[] = {
 Shahar>  	.driver_info = (unsigned long)&dm9601_info,
 Shahar>  	 },
 Shahar>  	{
 Shahar> +	 USB_DEVICE(0x0fe6, 0x9700),	/* DM9601 USB to Fast Ethernet Adapter */
 Shahar> +	 .driver_info = (unsigned long)&dm9601_info,
 Shahar> +	 },
 Shahar> +	{
 Shahar>  	 USB_DEVICE(0x0a46, 0x9000),	/* DM9000E */
 Shahar>  	 .driver_info = (unsigned long)&dm9601_info,
 Shahar>  	 },
 Shahar> -- 
 Shahar> 1.7.4


-- 
Bye, Peter Korsgaard

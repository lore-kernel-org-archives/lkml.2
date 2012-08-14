Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2HNKZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:25:43 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:44948 "EHLO
	homiemail-a91.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752436Ab2HNKZm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=references
	:in-reply-to:mime-version:content-transfer-encoding:content-type
	:message-id:cc:from:subject:date:to; q=dns; s=shealevy.com; b=US
	Oxi0W1ysZVQv1LcLaxjMf9FsJRBQSdbQRt9dVEPttNnMThhYwJoM3xvWLe3bwVW3
	Mi6vCivuOrT3EhsgrIq1u7o7TI23Fby213GKndXtXj9yCG4WPYOUQ0UhN5nMLL75
	SOSAME18VtL8ThRFesfx4joTpNjt4c+X616WJtdTc=
References: <1344374463-21231-1-git-send-email-shea@shealevy.com>
In-Reply-To: <1344374463-21231-1-git-send-email-shea@shealevy.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <7D86F475-50AC-42CF-8D29-C4E8F9B86D0D@shealevy.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>, Shea Levy <shea@shealevy.com>
X-Mailer: iPad Mail (9B206)
From: Shea Levy <shea@shealevy.com>
Subject: Re: [PATCH RESEND] Bluetooth: Add support for Apple MacBook Pro 9,2
Date: Tue, 14 Aug 2012 06:25:41 -0400
To: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Is there a problem with this patch?

Thanks,
Shea

On Aug 7, 2012, at 5:21 PM, Shea Levy <shea@shealevy.com> wrote:

> $ usb-devices
> <snip>
> T:  Bus=04 Lev=04 Prnt=04 Port=02 Cnt=01 Dev#=  9 Spd=12  MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=05ac ProdID=821d Rev=00.86
> S:  Manufacturer=Apple Inc.
> S:  Product=Bluetooth USB Host Controller
> C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> <snip>
> 
> Signed-off-by: Shea Levy <shea@shealevy.com>
> ---
> drivers/bluetooth/btusb.c | 3 +++
> 1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index f637c25..038acc7 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -73,6 +73,9 @@ static struct usb_device_id btusb_table[] = {
>    /* Apple MacBookPro8,2 */
>    { USB_DEVICE(0x05ac, 0x821a) },
> 
> +    /* Apple MacBookPro9,2 */
> +    { USB_DEVICE(0x05ac, 0x821d) },
> +
>    /* Apple MacMini5,1 */
>    { USB_DEVICE(0x05ac, 0x8281) },
> 
> -- 
> 1.7.11
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1DMP5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:57:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43693 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab1DMP5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110412143556.085500585@clark.kroah.org>
References: <20110412143613.GA19478@kroah.com> <20110412143556.085500585@clark.kroah.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 13 Apr 2011 09:57:29 -0600
X-Google-Sender-Auth: hRpRb9-UbsapUz4cd9PYE9hXiLI
Message-ID: <BANLkTimkv421jT1n-uuEx_gOSi2BNhBc5Q@mail.gmail.com>
Subject: Re: [076/105] Bluetooth: add support for Apple MacBook Pro 8,2
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Marc-Antoine Perennou <Marc-Antoine@perennou.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 8:35 AM, Greg KH <gregkh@suse.de> wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
>
> commit 63a8588debd4dc72becb9e27add9343c76301c7d upstream.
>
> Just adding the vendor details makes it work fine.
>
> Signed-off-by: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Tested-by: Grant Likely <grant.likely@secretlab.ca>

>
> ---
>  drivers/bluetooth/btusb.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -71,6 +71,9 @@ static struct usb_device_id btusb_table[
>        /* Apple MacBookAir3,1, MacBookAir3,2 */
>        { USB_DEVICE(0x05ac, 0x821b) },
>
> +       /* Apple MacBookPro8,2 */
> +       { USB_DEVICE(0x05ac, 0x821a) },
> +
>        /* AVM BlueFRITZ! USB v2.0 */
>        { USB_DEVICE(0x057c, 0x3800) },
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

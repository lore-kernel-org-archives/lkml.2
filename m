Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1ERKIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:08:42 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50163 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620Ab1ERKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:08:41 -0400
Date: Wed, 18 May 2011 13:08:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v10 2/7] usb: Configure endpoint according to
 gadget speed.
Message-ID: <20110518100828.GJ11981@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
 <1305637403-3832-3-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jITzwD3HDGXid3BE"
Content-Disposition: inline
In-Reply-To: <1305637403-3832-3-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jITzwD3HDGXid3BE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 17, 2011 at 04:03:16PM +0300, Tatyana Brokhman wrote:
> Add config_ep_by_speed() to configure the endpoint according to the gadget
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 5c4c30c..7d1188a 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -132,6 +132,8 @@ struct usb_ep_ops {
>   *	value can sometimes be reduced (hardware allowing), according to
>   *      the endpoint descriptor used to configure the endpoint.
>   * @driver_data:for use by the gadget driver.
> + * @bEndpointAddress: used to identify the endpoint when finding

we only use CaMelCaSe when strictly necessary (like on the structures
defined by the specification) here you could call this field 'address'.

--=20
balbi

--jITzwD3HDGXid3BE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN05qcAAoJEAv8Txj19kN1jyEH/iXEL1BupTaTqv1qbU0MWqRV
JPOBZU7ofFvelIJ1UnosW7x1q+PQjVibcgdCg+MgHMrnL5mJXsrHEIXGFojhPnEA
8B24Zw83NZqCBChEaFBgrVngmM7EAvrgt82wUB4e2bHVeI6W7/VCPKS4vtcXoz98
EUOSIcrH5W6fiyecy7oI6SstMF0lMUKHnkTZeEbif17gt09TOA9akdOfasqyhds3
JjUZFFV16YjtYST5EEcXb4mc/8pnwT5va4Y9lx4mGSNQ/C8FRY240OLm4bCCg5L1
cDk8PA96xbwHSSRB/oAujMrYLlgFizaVDzOqTillPZNQRgUfCrCNEmjzuFa5x9I=
=0Jgq
-----END PGP SIGNATURE-----

--jITzwD3HDGXid3BE--

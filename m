Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1JJHmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:42:19 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:35406 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752455Ab1JJHmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:42:18 -0400
Date: Mon, 10 Oct 2011 10:42:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mpn@google.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20111010074211.GC6685@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1314364322.git.mina86@mina86.com>
 <befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
 <20111010060212.GA31707@legolas.emea.dhcp.ti.com>
 <op.v24kw72ipw9a85@mpn-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <op.v24kw72ipw9a85@mpn-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 10, 2011 at 09:40:09AM +0200, Michal Nazarewicz wrote:
> On Mon, 10 Oct 2011 08:02:14 +0200, Felipe Balbi <balbi@ti.com> wrote:
>=20
> >On Fri, Aug 26, 2011 at 03:18:35PM +0200, Michal Nazarewicz wrote:
> >>From: Michal Nazarewicz <mina86@mina86.com>
> >>
> >>This commit replaces usb_gadget's is_dualspeed field with
> >>a max_speed field.
> >
> >missing Signed-off-by
>=20
> Sorry, forgot about -s.  I'll try to send fixed patches later today
> or tomorrow.

if it's not much to ask, can you base off of my "gadget" [1] branch ? I have
a bunch of other patches there.

[1] git://gitorious.org/usb/usb.git gadget

ps: that's temporary, until I get my k.org account back

--=20
balbi

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOkqHTAAoJEIaOsuA1yqREAycP/1oN2xZyWTLc6TYFuBA0p0Dc
Xvne5Z17F0L5bNEd2foR+jHpcQ96LBsFC2NmS4GG1ydQ5IhBsEkSwAvZR2VudDwp
YZoT1nEyDpcKzHHpZ3bFM5c8ozOiDgssDLoaDbwSHm6gyH8L/UEcVyAIp0UGXywe
Olh/pTDfThF/yCggmPPRqhUJJ04Z0wMV2hT6gIdYXb7p3f6Jh9+Lqrc1UnHHktvN
Ui+UKAbi8y4/5Xv/wC/jqCIkHfXhc7h+ljamP43NlPvVEHF6mtSEQkCC9RVvWdEk
BA1zQmT/c+9QLAmpok0ocix12V8362/gliLhmfceGpd2QGfnbV91ERhxegomb7RV
obrVytZsjNLiS/tAWXwF7WZfVMcTK8Rd0rG3/gb8iXVcKryPDQzkr+yjWFfhv21w
r+0FaNFEG2ZoWbmI04za9vhnPb3mrWf2V9stz4YKK2L6zIHNYudC2oXmqNAkBGFG
tmHHLq/VTCmZHmAxkmdBpmJiwQrFJyLXT2OCQ/efmW6C2bd2mcmcQqU/KWKCxIaN
9Ub7qWgiZVDzmXsgaO+fODF9fuUIuclkzXYYiPjMJ66edYvEbSFzyqpAF3uDnfpy
M+rydNNYjmMxeEK5sbblePqF8XfdjZ00EKoB1+pso42rC3pnNDUruWB7A8m6jrkt
0XRnxQ0ApLjrYxOEhOqi
=7NGp
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--

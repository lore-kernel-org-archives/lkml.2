Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2JZIUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:20:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40773 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043Ab2JZIUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:20:42 -0400
Date: Fri, 26 Oct 2012 11:14:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <balbi@ti.com>, Li Yang-R58472 <r58472@freescale.com>,
        Simon Haggett <simon.haggett@realvnc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for a
 disabled USB endpoint on Freescale hardware
Message-ID: <20121026081448.GD23501@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com>
 <1535820.NU10ADjvOZ@avalon>
 <20121022105601.GS14033@arwen.pp.htv.fi>
 <3862785.b8vaFMSbLQ@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <3862785.b8vaFMSbLQ@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 25, 2012 at 02:36:24AM +0200, Laurent Pinchart wrote:
> Hi Felipe,
>=20
> On Monday 22 October 2012 13:56:01 Felipe Balbi wrote:
> > On Mon, Oct 22, 2012 at 12:47:21PM +0200, Laurent Pinchart wrote:
> > > On Monday 22 October 2012 03:33:19 Li Yang-R58472 wrote:
> > > > On Saturday, October 20, 2012 1:37 AM Felipe Balbi wrote:
> > > > > On Fri, Oct 19, 2012 at 06:19:26PM +0100, Simon Haggett wrote:
> > > > > > Some gadget drivers may attempt to dequeue requests for an endp=
oint
> > > > > > that has already been disabled. For example, in the UVC gadget
> > > > > > driver, uvc_function_set_alt() will call usb_ep_disable() when =
alt
> > > > > > setting 0 is selected. When the userspace application subsequen=
tly
> > > > > > issues the VIDIOC_STREAMOFF ioctl, uvc_video_enable() invokes
> > > > > > usb_ep_dequeue() to ensure that all requests have been cancelle=
d.
> > > > >=20
> > > > > bug is on uvc gadget, then. Laurent ?
> > >=20
> > > We've discussed this topic a couple of months before. I believe that'=
s not
> > > a bug.
> > >=20
> > > http://68.183.106.108/lists/linux-usb/msg68869.html
> >=20
> > fair enough :-)
> >=20
> > That's a different case, however. At the link above we're discussing
> > dequeueing a request which is already being dequeued. $SUBJECT is trying
> > to fix dequeueing of a request for an endpoint which isn't even enabled.
>=20
> You've got a point there :-) That's a different case indeed, I'm open to =
(at=20
> least evaluating) a fix in the UVC gadget driver if you think that's bett=
er.

I _do_ think that's better. If the endpoint isn't even enabled, why are
you trying to dequeue a request ? :-)

cheers

--=20
balbi

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQikZ4AAoJEIaOsuA1yqRE3+0P/i23khVOl6XHW6nheK2QsTTh
vljymPE3/DjIF0gpSo3CmE/iJI2Rfv3WLOppfiTZLz8tPsidyJ81D6A43fIUFqbn
LRt8LGmsYmXHivetORjmkbn9tY5Bq8FwwS2HCTrxMKArhhMo3heTohNAfPMv3+F7
pGnbFpci5GabUygU2OOZnxZKNmAcA3+yYtfGV3PIDsx3Kws+O44OBF4AM3X1F5cw
irIbPAGiMMsJp4siSWnTjQRRHI7S64M5n8DE494DrnqEP0lLeeIZ72x8ETndZ4N2
dmuE8nPf63F4UoGV+UeOjej2xgzLOJ4DOzBJeBAJVefb2VMb7n+RCdncNyLv6Hrq
98NkJDTc1D1C91+KMMl4tkIY4Ji2M1/po9XUfhvWNl8CzHYO380wYqUCOqhIQ2sK
0MhNVJ1kgeAIA5rywyOsX84ZCo3LnCrTZkq95rhG2PKwgZiPlMju1XSVUyxXLepm
X/8mtnDuo1Kw3u86/EZ49d99VH53nsYso5blBgC4sJ/YEVeEkSZSzbAhWA86K2Gk
ezftfTCyfvV2w4VbL8sw06g1gYzD2ExYNyV35zunjr/ioEOoPKK5mBz31f+gnZc4
Fis0rHCmukzgn8Oj+DU4j/pQ7hD0bXUvsGbhSF/6ekL7/2/a7rgkmN/ZMuuwGb5Z
x3XcZZMgzC1FE7y1rsP/
=vNTh
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--

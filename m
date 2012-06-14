Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2FNLKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:10:47 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:44804 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755261Ab2FNLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:10:46 -0400
Date: Thu, 14 Jun 2012 14:08:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, a.zummo@towertech.it,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: twl: add missing IRQF_ONESHOT
Message-ID: <20120614110841.GO13602@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339669606-9579-1-git-send-email-balbi@ti.com>
 <CAMQu2gyPTJNNV5T4jN4eD+sz2e_qYqG0HY9R+ByBw_mDY=ANGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vzUQzca511KWT6Hk"
Content-Disposition: inline
In-Reply-To: <CAMQu2gyPTJNNV5T4jN4eD+sz2e_qYqG0HY9R+ByBw_mDY=ANGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vzUQzca511KWT6Hk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 14, 2012 at 04:38:34PM +0530, Shilimkar, Santosh wrote:
> On Thu, Jun 14, 2012 at 3:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> > This patch gets rid of the following warning:
> >
> > [ =A0 =A02.825378] genirq: Threaded irq requested with \
> > =A0 =A0 =A0 =A0handler=3DNULL and !ONESHOT for irq 363
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
>=20
> Ming Lei has posted a similar fix earlier [1]

good, never mind this one then

--=20
balbi

--vzUQzca511KWT6Hk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2cY5AAoJEIaOsuA1yqRE/dQP/A7mvYgPVkt+I8Wg6jVNJNZK
CvqT/mmBW34z3mjDU1PNTb0o84tebczy6Qx1qgLACSetkBGeU0mvsmVeBGqZBolQ
v2a6zBKgR+KhZIwq6iM+wxmT1kZTNF9qMBwPnGjH08WaBqfqIu/lwDyXNMNUsOfg
j+4zJnagb3xycLgr/FG5xQGYwYYWmTBdWjVTqdxmX2YjsgHgqNKFS1EY+2dVSM6W
yqSmNt7u/3sCsSPdXArTuqWlPPxGEACXVBGLzLQ36IiON5tzDALOC37kHoOHfeoe
HsR/kb4vlD3SSrNxZ1e2VO/OZt1vJiWb1MQ9NAHJhPWzH++LhkOkQ50Y1mvhAn9b
b8xrlClJB32FV9ztJvoC7BIoZK17ZoiOLL821UCMjIvsz6j02YGtAYE8r8LTGIC1
tx2hNACf+LfhDiHeh1+7zQz3L8y4+7g0FB70J9hC7TPJxE8iZojbUh0s5YOXev+B
Ri60TPkWQErgu5UfqDGxsKFAYAGlBcuSYL9/2zS9hcyE0g2cKyrDOde8K3NMfqhz
cGkGHAUarSDe9tmoN0TUzlBx56wIqR1LqgFfqAZVYu9J53lyi1H7lxf8+0VkCqX4
M2cxfoMmMcnKbEC9AXSdfQL+xK0g+FKdRKy6r0x2Cd8Q2bV+Qs1JKXSyAG2N+O8H
fpEF5NrqBTM86q23VK+k
=xqUN
-----END PGP SIGNATURE-----

--vzUQzca511KWT6Hk--

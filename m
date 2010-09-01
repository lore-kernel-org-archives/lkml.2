Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0IAT56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:57:58 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:35745 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0IAT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:57:57 -0400
Date: Wed, 1 Sep 2010 21:56:17 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Ike Panhc <ike.pan@canonical.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control
 rf/camera power
Message-ID: <20100901195617.GD32589@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Ike Panhc <ike.pan@canonical.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Corentin Chary <corentincj@iksaif.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"Brown, Len" <len.brown@intel.com>,
	Matthew Garrett <mjg@redhat.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
 <1282127719.2747.211.camel@localhost>
 <20100818155128.GA24363@darkside.kls.lan>
 <4C6CA31D.6030407@canonical.com>
 <20100819193146.GB32665@darkside.kls.lan>
 <4C6E2833.6080407@canonical.com>
 <20100820090824.GA23186@darkside.kls.lan>
 <4C7505A2.3000402@canonical.com>
 <20100830181954.GE31068@darkside.kls.lan>
 <4C7E3DE0.7030209@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <4C7E3DE0.7030209@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 01, 2010 at 07:49:52PM +0800, Ike Panhc wrote:
> Your log tells a lot. It tells me if the bluetooth init failed. Then we
> have to turning off and power on again by hw switch to make it alive agai=
n.
>=20
> So, I believe we have two issue here.
> * when rfkill unblock, sometimes bluetooth init failed.

Yes.

> * power up system after rfkill block bluetooth, sometimes the cfgbit =3D =
0xc0000
> Am I correct?

Not completely.

* reboot system after rfkill block bluetooth, sometimes the cfgbit =3D 0xc0=
000

I never had cfgbit =3D 0xc0000 when I power-cycled the system, only when I
rebooted it.
This is why I belive the second point has virtually the same reason as
the first point: bluetooth device initialization fails and thus its
detection by BIOS fails and thus ACPI returns 0xc0000 cfg.
Hence, I belive chances are high that solving the first point does also
solve the second.

While thinking about it... the init problems persisting a reboot could
also mean that not the unblock operation is the real issue but the block
operation - which probably leaves the bluetooth device in kind of a
semi-disabled state or something like that.


regards
   Mario
--=20
Do I contradict myself?
Very well, then I contradict myself, I am large, I contain multitudes.
                                                       -- Walt Whitman

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTH6v4RS+e2HeSPbpAQJcIgf9Fb9gg0wHorstDFb2khVF9kDP0CKfv8JJ
7AY+qGgz0Mk3TJhAb0p6mCb3YqUIWxnWfILGmamgyLOvTy/4l0BA7JH4FJxv6VK1
9gBMtPSU8DL7VlsKCv+8TwDbEyCtyIjTf1KpBOBF4AY1ojpAQVhTbh6TqsKYuWXn
qk/hopjtY5t1Y3ipcWsGrDdJMw9zgHHMh0KfUjQpWR3USDVi3wXYSieWPCOpy95f
iC/ja+9w/CGnQGyM+ZL3K60sgm1uoWl77Ti4g3eTkiK0XojmX6a0qjg/cs1kP4/L
oBJkhFcZgmI63UCufVFvozbJhl/RpYFkmrmqNsFHR5g4Z4PAAQcusw==
=sdGT
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--

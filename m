Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab1JFPgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:36:16 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51672 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758558Ab1JFPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:36:14 -0400
Date: Thu, 6 Oct 2011 08:36:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v4)
Message-ID: <20111006083607.2c4eb9a5@jbarnes-desktop>
In-Reply-To: <20110930165403.GB31760@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
	<1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
	<20110930143211.5ab39c02@stein>
	<20110930153321.GA31760@hmsreliant.think-freely.org>
	<CAErSpo56QU78RHE0UOcvcT5iwcis1o_Ue=ZLPQ3GhdB483-L4Q@mail.gmail.com>
	<20110930165403.GB31760@hmsreliant.think-freely.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//.UdPaoZ8lUbDN2w._MtlVh"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//.UdPaoZ8lUbDN2w._MtlVh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 12:54:03 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> On Fri, Sep 30, 2011 at 10:33:36AM -0600, Bjorn Helgaas wrote:
> > On Fri, Sep 30, 2011 at 9:33 AM, Neil Horman <nhorman@tuxdriver.com> wr=
ote:
> > >
> > > On Fri, Sep 30, 2011 at 02:32:11PM +0200, Stefan Richter wrote:
> > > > On Sep 29 Neil Horman wrote:
> > > > > (v4)
> > > > > Fixed up some spelling mistakes, and added a scissors line with a=
 good
> > > > > commitlog, so that git-am drops all the version logging
> > > > >
> > > > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > > > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > > > > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > > > CC: Bjorn Helgaas <bhelgaas@google.com>
> > > > > CC: linux-pci@vger.kernel.org
> > > >
> > > > It drops these last 5 lines then too, doesn't it?
> > > >
> > > I would have thought so, but I tested a git-format-patch / git-am ope=
ration here
> > > on a temporary branch, and it worked properly.
> > >
> > > > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > @@ -66,6 +66,24 @@ Description:
> > > > > =A0 =A0 =A0 =A0 =A0 =A0 re-discover previously removed devices.
> > > > > =A0 =A0 =A0 =A0 =A0 =A0 Depends on CONFIG_HOTPLUG.
> > > > >
> > > > > +What: =A0 =A0 =A0 =A0 =A0 =A0 =A0/sys/bus/pci/devices/.../msi_ir=
qs/
> > > > > +Date: =A0 =A0 =A0 =A0 =A0 =A0 =A0September, 2011
> > > > > +Contact: =A0 Neil Horman <nhorman@tuxdriver.com>
> > > > > +Description:
> > > > > + =A0 =A0 =A0 =A0 =A0 The /sys/devices/.../msi_irqs directory con=
tains a variable set
> > > > > + =A0 =A0 =A0 =A0 =A0 sub-directories, with each sub-directory be=
ing named after a
> > > > > + =A0 =A0 =A0 =A0 =A0 corresponding msi irq vector allocated to t=
hat device.
> > > >
> > > > "contains a variable set _of_ sub-directories"?
> > > Gah, bad ispell foo on my part. =A0Bjorn, can you add that in, or sha=
ll I repost?
> >=20
> > I'll try to remember to add that in.
> >=20
> Thank you, apologies for my poor writing skills :)
> Neil

Is there a final patch available for me to queue up?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_//.UdPaoZ8lUbDN2w._MtlVh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOjcrnAAoJEIEoDkX4Qk9hikcP/RRf/QTw/uLKScGMgU8ZqrHY
KaSd26eg0Vm6VY/yNOXK07OxQnr+ROlEhdwTA96frz6yR+RvW+Nk+Bk2xsGcKb2H
T0ehbrb12uJSmPAh3TcukkeYnInN6jQbMgLkoyQ7b+2o6YCg6hW8rDHeWFHpJdfG
lxHXSDWe8vUUXNOmq0LPCBdmg28Nsti8Q7RV/IvooF+n+ljhMVb3oJgS3HD43/lc
qgFMkR661tUXDirZoB19zNK72T88ekh8LwzVXnBzDebkcBf9qDrg2ZMWk4SJcZON
WpMvS5s326xWz9AH0bm56QlZBi6Cp/TtEys1cd5+hk7xKt9hycyS/xJhIXi56M1B
PHgXKUlT2N5c2yJQWotg78t+n4+j06kcu57X2jmJ3sZdU9rTpCaUsEEGIZpHVtzU
/B+TWo7g6/SXa4hY90bjWQT6+zL9J/m81HbiuVeVWDAE3Ufy7W7LlYTVzJYR4L19
Lkc64HRrDt5ZouuwYz/zhAHIK2/pixibAvXlDDCLOLsAxJI55May3U6DpImhbAhy
be4e210gSVAG3u4OEgoRDNFcqSXBtbTvQQzIcGO0iOS7mCnGdcCsh9NaLFFZyWiK
nJZlCARn982CIcmUPuLNZ8lHvKedd8HgVVxrNGnHfiZS/KKvJjIh0UIe4lzSUr1P
F9835psKpM1MOgmHOrxH
=xGrH
-----END PGP SIGNATURE-----

--Sig_//.UdPaoZ8lUbDN2w._MtlVh--

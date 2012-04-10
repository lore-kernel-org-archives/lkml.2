Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2DJQ02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:26:28 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55246 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754176Ab2DJQ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:26:25 -0400
Date: Tue, 10 Apr 2012 09:26:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jirislaby@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120410092619.26a15165@jbarnes-desktop>
In-Reply-To: <4F83F3B5.8080704@suse.cz>
References: <4F717CE3.4040206@suse.cz>
	<4F717D80.9040207@suse.cz>
	<4F758400.3080907@suse.cz>
	<1333104359_155028@CP5-2952>
	<20120409101119.47e770b2@jbarnes-desktop>
	<4F83F3B5.8080704@suse.cz>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eT_Um6FH5Vz_02j1=HNNku9"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eT_Um6FH5Vz_02j1=HNNku9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 10:47:49 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> On 04/09/2012 07:11 PM, Jesse Barnes wrote:
> > On Fri, 30 Mar 2012 11:45:43 +0100 Chris Wilson
> > <chris@chris-wilson.co.uk> wrote:
> >=20
> >> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz>
> >> wrote:
> >>> I don't know what to dump more, because iir is obviously zero
> >>> too. What other sources of interrupts are on the (G33) chip?
> >>=20
> >> IIR is the master interrupt, with chained secondary interrupt
> >> statuses. If IIR is 0, the interrupt wasn't raised by the GPU.
> >=20
> > I've actually seen cases where one of the PIPE*STAT regs is stuck,
> > and even if IIR is 0 we still get interrupts... Jiri can you verify
> > the PIPE*STAT regs have bits set, maybe one or more we don't check
> > for?
>=20
> Note that I already attached their contents... This is what is in them
> (pipes 0 and 1):
> [ 3572.968581] i915_driver_irq_handler: 0=3D00000000 1=3D00000000
> [ 3572.977472] i915_driver_irq_handler: 0=3D00000000 1=3D00000000
> [ 3576.224839] i915_driver_irq_handler: 0=3D00000000 1=3D00000000
> [ 3576.243558] i915_driver_irq_handler: 0=3D00000000 1=3D00000000
> [ 3576.384912] i915_driver_irq_handler: 0=3D00000000 1=3D00000000
> [ 3576.403462] i915_driver_irq_handler: 0=3D00000000 1=3D00000000
> [ 3577.464100] i915_driver_irq_handler: 0=3D00000000 1=3D00000000
> [ 3577.477383] i915_driver_irq_handler: 0=3D00000000 1=3D00000000
> [ 3577.829016] i915_driver_irq_handler: 0=3D00020000 1=3D00000000
> [ 3577.830093] i915_driver_irq_handler: 0=3D00020000 1=3D00000000
>=20
> I.e. the handler is called when IIR=3D0 and both pipe stats are 0.

Oh sorry missed the PIPE*STAT, I thought it was IMR or something, I
should have read more closely.

So port hotplug is always reporting that port C has a hotplug interrupt
though...  If you write 0x3 back to it does the interrupt stop?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/eT_Um6FH5Vz_02j1=HNNku9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhF8rAAoJEIEoDkX4Qk9hei0P/jmsu/9Bpp/dkJzargj1eL9y
yrROsASphkjHK/1DvmFpZ9fupbf7Z+5+cxfB+bkPWBxld5nTkQVISTARHSfqsSWL
w/OPwAb29RMAaljwPHtGd5HALCmRIYozLLX4RfQUBdCBXsZkzfmRNsXLb2J9y8QS
F3Qcl1Xy2Xb/T1o5Fe2Pi6myk9xiklAUqo78l2JqYLPTJDQnf5qMpyuCFOfvuDqd
FDKPe2hW7y+UbviTgozlmJ6r18nWV2MYgYSJoEVUy12haH/s2wdGvXRuQbWPLGrU
qCuDdi3K9bd8K3YnA2ShVFLuDKNxY7YCzUaKSGhYHwoSQuwSygk3DelcBiGFZp8X
Ki4HGsketAwMvvxx+L30u5wPpS3c8Dzbs8BMM78nQ+6smK0+naXpSbC2u9UYsFxg
+Zlhp0BEaI4YMCcbtc3hZ8F/xtvi9fbhLcRbOapiLGLb5G5s3WUlX/q1lC2F3OOz
oU2OImpa8SkTNRoFGJuOEzai1v7GRCu1vz5rimRr6Ve+WoDXlVnhkXxC5kAu6meL
Vo9KcLvg9fwTVd9M4vzHaf6S3Tav2l4adBFYCWn7j9NWP3Ni68cDtvGCrdeLJdcw
WrHo/mh/n2bXDk7MDd8x0PTdKYGV89Y6z89RnrQUVPdcDL+P5n0rIlfQFwDYrxLp
vcMMkDSheaE3HWNOAbMQ
=8zWT
-----END PGP SIGNATURE-----

--Sig_/eT_Um6FH5Vz_02j1=HNNku9--

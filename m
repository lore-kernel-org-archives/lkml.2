Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2ECPYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:24:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60401 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771Ab2ECPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:24:12 -0400
Date: Thu, 3 May 2012 16:24:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503152407.GK3955@opensource.wolfsonmicro.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120503103848.GB3955@opensource.wolfsonmicro.com>
 <20120503112803.GA15752@localhost>
 <20120503113801.GE3955@opensource.wolfsonmicro.com>
 <20120503150040.GC15752@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nzri8VXeXB/g5ayr"
Content-Disposition: inline
In-Reply-To: <20120503150040.GC15752@localhost>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nzri8VXeXB/g5ayr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 05:00:40PM +0200, Johan Hovold wrote:
> On Thu, May 03, 2012 at 12:38:02PM +0100, Mark Brown wrote:

> > This is one of the reasons why we currently use tracepoints (they just
> > don't have this issue as they're trivial to filter), though
> > adding some sort of infrastructure for it ought not to be too difficult
> > even if it's just at the regmap level.

> So a /sys/kernel/debug/regmap/<device>/io_printk attribute (with a
> better name) to enable debug printks in io paths
> (regmap*{read,write,update} outside of mutex) in regmap.c would be
> acceptable?

Yes, that'd be totally fine for me - it's debugfs so we can always drop
it later if someone comes up with a better idea or something.

> > Actually, the other question I had but forgot to ask (or I think punted
> > on for your response) was why these are in sysfs at all - things like
> > which things are connected to the backlight are going to be a property
> > of the board design so should be defined by the machine not tweaked from
> > userspace.

> I agree with you and the reason is the same as for the max_current
> attribute (discussed in the other thread) -- it was an explicit request
> from the end customer.

> I could replace the boost attributes with a platform_data entry where it
> really belongs.

I really think this is much better for mainline.

> There is a use case (beyond testing/integration) for keeping the (lvled)
> outputs configurable from userspace, in that it provides a way to
> synchronise LED activity such as blinking. So I still want to keep those,
> at least for the lvleds.

I'm not sure exactly which control that is?

--nzri8VXeXB/g5ayr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoqMQAAoJEBus8iNuMP3dJFIP/0RZs0Mbg/s4hAvFt0u3xfyh
7uZ3v6Jt8qfW7+JuyeoDNGRSeF1WgVBvxZtGpRewrSW62j7O+sbm+cK0d7dbDOuF
Qtt9GO4H+gRSzSaivLnA6jqGoX0FLXDTvBMfaSmCJKa7XcEJIufWlBhTXwlX3AJT
BmgnXNwABQQXaDle4fDqQ5jDzKUkM/5sgK8plaxTRmQIaawOyksSz1b5qBPMvU0v
PdSQ53P6e7m4Xz6XYwCMAc+Ab9EvliAPyVFFIdQan4fKeDL7TIvQoI1fkbHy2qBB
rrFhMTLpV3JJC6mE5C/ajA/rxLwOm2p3EbRKvskBC5DWphGJQGPf3AYj4MeH2YUQ
o6wSfUEtKbFwNsBdMev4/2d+bE2sW7vH9fOiwPElBGudGrwhLsIARdh3LXIAxK54
xIQ7ay8DlBoXlMBCgLNIdYKv6RLN8gPhZfCfVMEAttY2l9lIITvdzO4JVeDurX79
0RLzeZDYE+7lnIE3FqBQILakrTi/zgGKh6ucGkGVtGZcqC++aTJQKLlceEEHtKoy
54+KUI7Ppk/BsGl+oj7PhF3IKrHMwdCswaOaDKR9Ft7+oW5cWBEDwMJeMF/QeLSz
rmgWPrUdZ6Apl/i8KIR3jCaAjfvIIrcoC2ikoxQ+9xf10cGrD7S89ptEGMAb+0Ap
jWvQXfVGObAWvX7YCIzM
=spwq
-----END PGP SIGNATURE-----

--nzri8VXeXB/g5ayr--

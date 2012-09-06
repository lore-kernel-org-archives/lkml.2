Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2IFMgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:36:07 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:59437 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab2IFMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:36:04 -0400
Date: Thu, 6 Sep 2012 15:31:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Felipe Balbi <balbi@ti.com>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Vikram Pandita <vikram.pandita@ti.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 20/23] serial: omap: fix software flow control
Message-ID: <20120906123136.GD29202@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
 <1345717983-18179-21-git-send-email-balbi@ti.com>
 <20120905202749.GA2451@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
In-Reply-To: <20120905202749.GA2451@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05, 2012 at 01:27:49PM -0700, Greg KH wrote:
> On Thu, Aug 23, 2012 at 01:33:00PM +0300, Felipe Balbi wrote:
> > From: Vikram Pandita <vikram.pandita@ti.com>
> >=20
> > Software flow control register bits were not defined correctly.
> >=20
> > Also clarify the IXON and IXOFF logic to reflect what userspace wants.
> >=20
> > Cc: stable@vger.kernel.org
> > Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> > Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
> > Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > ---
>=20
> If this is a stable patch, should it be pulled out and put also in for
> 3.6?

I'll leave that for Vikram to answer. Vikram, do you think this is
something so extreme that we _must_ apply it now, or can it wait for the
next merge window ?

I mean, I think this bug has been in the driver for a long time, right ?

--=20
balbi

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSJeoAAoJEIaOsuA1yqREVQAP/ResJg0kjUVuMP5MVkscWsiW
htdQ0UpvOB0HomtVI4/tSKUa24jY1oEz3oHNc48dNqymjEBaYwWBjy45m7rS00rF
XA9zj5V2fy0egyuh3hzOd1aEWDCbiQMcN0galLcRLTOXUZerQUMe17vDCEcw43Eh
TdLQxr+BTViWyFrNkTfUYiR/ZwBtgEJhRjhL/0ISlgv8g9Mh+waU4jfcTL5Xqebh
1Or3pkzLDGHFNxaxFyiSBu/F7UWOJcTX8kZs51QSExO93q2GZO+Nnqwzo7hDBuJj
jW8aJuwc7aQk4c5fiawHdMCUN47Q5bc6d94rQ5v33RWk8CQH1K2DGmmGY6RxRGii
kprHEzrpmYmBcDLKJdYH6L8OGAYdDbwcVzv7VF66yU2bthQIpLQVwGELP2ChMrGR
j8KGlg9PSKqC9fcNWTiBzjL9Bh221y5GjzNMGxcMWOO1wt6HP2RLAj7kccuyWNtz
lzI7UmkN05nW+CK+WTsc+9Yx/urtSmb+BeH8uMyk0uRwl6FiWERu6oe1TF63LMOJ
/5i1Ijh14nSFJ3F7d3JjhEwoPY4VebxzG/yOWL304DAvJCF/Fd9vUSKQiPxlbUkO
dNuXz+Wygppty8OG4RvjJEX2Mxl7SjDv4pS0mW9paVC8RY4rU9nF5wZ/yIEOA9eI
gd4eUSeK+0/im1L2CZc3
=K8s7
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--

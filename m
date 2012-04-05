Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2DEJrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:47:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48853 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686Ab2DEJri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:47:38 -0400
Date: Thu, 5 Apr 2012 10:47:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 2/2] regulator: Convert rc5t583 to set_voltage
Message-ID: <20120405094735.GD3129@opensource.wolfsonmicro.com>
References: <1333605888.18055.1.camel@phoenix>
 <1333606056.18055.3.camel@phoenix>
 <4F7D4358.50000@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <4F7D4358.50000@nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 05, 2012 at 12:31:44PM +0530, Laxman Dewangan wrote:

> I wanted to provide the settling delay whenever voltage output get
> change as per datasheet. In place of having this delay in the
> driver, I wanted to use implementation of core and for this I need
> to implement set_voltage_sel() not set_voltage().

The correct thing to do here is to make the core able to do this with
set_voltage, which conveniently enough Axel sent a patch for yesterday
that I've not reviwed yet.

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfWoPAAoJEBus8iNuMP3dt0MQAIyHmRedmeRc0kpJBGsfhAx+
RXqHzlf6ihCjTt5eF1/4A5YpIP3kVaGeoFbDhTRMyh8B6LTwXbQRjpqKseK5tw8T
ChbKfJNPxuYbt7SrZkV21a2PcC4iL+WBvQRmP1nrRVDoV3XzqSFlABJ0tP6SXOM9
YlH5ulcGSZQL2UQQX/QFaD21m8fQRJ8bCuGTStGRw4yrzIuaWbW/WUCi12qsOy9Y
8uvQmUs7wnPqEs13UeF8xhCyTfdVzrZWNnoFP7OFeYOgBuKfe7eTeSvMK/SELu4o
F9w2L2Hc6juql0VXfRxzqllnBdTKFH+WW44AesjlsHq2sI15m5s3lNBdDpOCArpv
YPeirkrRNPG/OadqpIrJwv/GwYPU5jCNyQpdN6jBY6ePAToHkSn34bqCPAcb8vTi
hgw+4Hhr86B9RTYgzM7UiYqbov3Yw5X4g5/2Pt6xSfIwPs+jkbLtfnUIXzTTn5Rv
QryXGeFPFbVpaCzF1SHw+1nInwXcluM24BFHLfTU35D+Arde9elSseOP1PNy1tbn
gE7+bSvSj8N7lFY/AI5ALmihAPwwCu0qsh1R2U2PhKJKjzsfjSVdxwhfIrYa3skn
BXqhLdviAS54ndDs+1fNbn9DIZYqDZD6ca2+hPn7n1UPIWS0ygegWFDk3lBUsgZP
odcvDqn6cg7ykY7y6LJd
=ERVw
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--

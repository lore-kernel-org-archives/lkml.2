Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab2GCThQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:37:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53157 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933032Ab2GCThO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:37:14 -0400
Date: Tue, 3 Jul 2012 20:37:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        =?utf-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: Re: Re: [PATCH] Extcon: Arizona: Add driver for Wolfson Arizona
 class devices
Message-ID: <20120703193712.GA27375@opensource.wolfsonmicro.com>
References: <23829569.63411341203851815.JavaMail.weblogic@epml05>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <23829569.63411341203851815.JavaMail.weblogic@epml05>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2012 at 04:37:31AM +0000, MyungJoo Ham wrote:

> I'll put this to git
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next
> after testing with the MFD part of Arizona drivers.

If you're maintaining this tree could you please include it in -next so
things get integration tested?  I guess some coordination with Greg is
required, there's a bunch of patches already queued in his tree for
extcon.

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP80nhAAoJEBus8iNuMP3dip8P/jGF9YX8ax3QPWdr327B5+uv
v1mzLz+LUhy3JH2QNm0CvOkt9sb6WzA+MJwyRedxL/KKj5QSPdd5MYmswy0E1RLo
UblhzIPUwJGdogBj6bK+QVD+4jTKdO9rNaCx97dLrrl+SzgFSCkiBjnNPc92G2ly
dbhKBSM5FA/EgxdWCK0I4QEoDwGD1BV7RoVGHaAWOXNoTeofDUhJw05vwLjaUc91
lyG/kQPvoRTU4zchbuSpAEAYHBZfvl3XyC77Nu1vBAMb+79P/3dGhL8SnNnL5hwY
BJjMACGq0pdzofBgYYoQygszFQOqnuwK4vqmuODHrDocCb1KVUeT84wLdyak8Osf
XVzRag6EMVeB3Bl/3A8FCSSWYbs0URGk1pShFDwhZ/XXbNoQto5SaJINx6x3owMh
H4pYlXrezng2pcH9QVcCpgP97XLruoiGOAFgtqXplL6TpXLv1rOtZhDqZoxFECqe
J6UblfYUEc8mUozpNBM3HaTg6YxXLRAzY5W8kYRNyQi8MGe3dLAtUtQWmAsg+GX1
hiZpMDBNRxZjoTivlzhO8QQKRgzxc/OiF3+2INmVhv9gIwkg4Eh9YWkjghgx+1VN
e2S0mR/tiwyqXIomNWXYt3wlbIvdIZqnYMumMQjz8l9D1YC9JTx7OdxuPOyQmUVm
m0GdfpeEOVLZ8vWNsSj6
=5oS4
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--

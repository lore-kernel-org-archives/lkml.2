Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2A0VMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:12:40 -0500
Received: from comu.ring0.de ([46.4.151.82]:38267 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab2A0VMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:12:39 -0500
X-Greylist: delayed 1921 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 16:12:38 EST
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
Date: Fri, 27 Jan 2012 21:40:33 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Joerg Reisenweber <joerg@openmoko.org>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Subject: Re: RFC 2: bq2415x_charger driver
Message-ID: <20120127204033.GA27821@earth.universe>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
 <1677656.4d3iQHNZjX@pali-elitebook>
 <3531484.T8K8kTguQQ@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <3531484.T8K8kTguQQ@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 27, 2012 at 03:40:43AM +0100, Pali Roh=E1r wrote:
> Driver has power_supply interface (without new charger interface -
> due to compatibility with n900 kernel 2.6.28) and additional sysfs
> entires for configuring bq chip.

IMHO the new charger interface [0] should be used. It has been
written exactly for devices like the N900. The aim is to get a
proper driver in the mainline kernel and not a driver for some
deprecated kernel fork.

[0] http://permalink.gmane.org/gmane.linux.kernel/1237755

-- Sebastian

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPIwvBAAoJENju1/PIO/qaLkQP/2V7MZGlymK8JMVLZYlfRRlV
9Mnk1S93+B1xDLP7JbVUpZkYMH9KG7J4qXQv1pCIQ4u9Ck55XBrqns9SGVPg6Pae
owk98ML54qM0Mk5axQN2w3xoaT3ygPEz+U9V9E8ycTEnR+Pr0RI2VVwCrOfhh7g3
1FQ/t4+69CQiE++TU0QoLda4mD4PnE5hl1oIccAt5fUEQ3Lx8TG5FTYfYuaGg67S
4YvriazVAneO4iPKtkJ6Ev1KxxarxVQeyKir+ychxECim2o+HRVYpl4CPnTx1/lQ
3dl29QMSLx2yAgWNAdbyW3vh7MjdxL1d+bYu44vnf1MJFmeuSGZZJAx+YUqLHHh3
uiBoeEU/6LX5Jn20i2frNHqnEltJ6q1uMVAanaWQMGrxqTfwuc4PGm4h9KJGWarz
IYSYGh1p9ow3W6gOrNRT/oshQm8s1iPANKOzFwrBO83YIC/yyqasgrbTk4zQ5pGt
5KY13hwH94wJlMcD2mZxhzzgEaTNwJ44viyjbPo+t5zrdBszntFdRX5K9XBIYIRl
f9E1IhPlGRagLCCnImQ6RYycQeKVGWsy3N8pIUcYsPTNb9RdQKEsBlFnFi5ydFhL
u1lTOgu4eiAlvPIZNEhx1CXKxJ6K7IUc+HfLzWlYY17W5bmotwv5fquZLoERH2kV
ZwTOQDS9tl/htRTpfocj
=0gbK
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--

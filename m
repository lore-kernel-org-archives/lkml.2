Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1FIJqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:46:08 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33441 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757115Ab1FIJqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:46:04 -0400
Date: Thu, 9 Jun 2011 12:45:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 8/10] usb:dummy_hcd: use the shared_hcd
 infrastructure
Message-ID: <20110609094556.GI13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
 <1307360469-29120-8-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qhD8kUEc5MK9MdKG"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-8-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qhD8kUEc5MK9MdKG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 02:40:52PM +0300, Tatyana Brokhman wrote:
> This patch is a preparation for adding SuperSpeed support to dummy hcd.
> It takes the master side fields out of the struct dummy to a separate
> structure. The init process was also modified to resemble the way it is
> done by xHCI.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

applied to gadget branch, thanks

--=20
balbi

--qhD8kUEc5MK9MdKG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8JZUAAoJEAv8Txj19kN1g4UH/R4BzF4ai4ULptq6B468+N7Q
tDIn+9ctxbUv0Lxsz+ceZJzEoSixhGI2M/I2atUHf0GEQQkhjKvnqLINbVn9vZzZ
JOaOQXEB2fUO4y2Ude38u6cRoPzeOrnYAq95jhdJcPWv0eNmbRq+H6ZupiJz+a6K
lfW+YnON7RUfzu6thgfqGMv3jDFsb6dNdBrDSQ2OwbnWCDjWbXHf0hyTbks9a6hS
C5XgqGcrT4GDLZcla+0tcjTlUucTKonYix1OIsAKi/nsG50jv7paSwZ2Gthh4RsN
7NZFi51aiv+SMq+nzffgSQZ0VQULwMmJ020DMFs3nnhewDEDj+skvlHTiSD0c7o=
=9b/u
-----END PGP SIGNATURE-----

--qhD8kUEc5MK9MdKG--

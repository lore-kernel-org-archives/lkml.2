Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383Ab2ERHix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:38:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45264 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759323Ab2ERHiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:38:52 -0400
Date: Fri, 18 May 2012 08:38:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, AnilKumar Ch <anilkumar@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert to set_voltage_sel and
 map_voltage
Message-ID: <20120518073849.GE4073@opensource.wolfsonmicro.com>
References: <1337066278.7340.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
Content-Disposition: inline
In-Reply-To: <1337066278.7340.1.camel@phoenix>
X-Cookie: The time is right to make new friends.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 15, 2012 at 03:17:58PM +0800, Axel Lin wrote:
> Convert tps65217_pmic_ops to use set_voltage_sel and map_voltage.
> After this convertion, we can also use tps65217_pmic_set_voltage_sel()
> for set_voltage_sel callback of tps65217_pmic_ldo1_ops.
> Thus this patch also removes tps65217_pmic_ldo1_set_voltage_sel() function.

Applied, thanks.

--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtfyAAAoJEBus8iNuMP3deb0P/R7SGeL7FfkITE06UWGOTjaz
4hlktkEIUrx8F2IvRJOduPcy/r9UzmVyfgM6QEr9eZ+RP8gYMk7NC+eRfnDDKktJ
SXWMT0RdpuTD5eOp00BsfQZN7UEoYQrjn3C31ZR6ftj7J8iaTB9w6nPnz5QIGM+6
jdN46lZkc+IgR0Ej0sEHCVeMYttEZu8o5Y2DTQmA9MHfLY+OUWyvaumX4LN72Mmq
stTaxBGnMbo/nh/X3ZCjsZPbAPSSHS2e6cE/tEodICsQx+M66RdlrvTZYW+bb6hb
IQf3ly3ayjSNDZSJMw00IiVYPs2Bp8ma+LsBPYyYl0bT/QauWvctvGhEuRH1ztVL
NsM8bJSsCfHm9rkMPzzRCkvQtpQpXPa0WnWdWoiqf7KpMlyVfevX30NF4Amo6YVG
MxugLAYAR266z/bBCu8N7YyHP1EF9yeRcDocXUdTHSwQN0eMbnw+2FPSXEgpb/QC
SZXLZrytK541mf7LY8aYaHNzT3Z9Fat4DC57MdUdjAiDTpQTzY8Z4veBBp834vZG
dACCOkLXwmqm1VPd3ZfQuHNMZnOot6tujAq9Ua/1nFTUdCm0shSu3VzM0tpk/SEp
jHLRBugiAWnMEfypVgzjO9UzCNx8IT0aPRTQmEh7mY29PsdijBNElB8Kc8QE/vbF
bP7uWEAmEYPPs+7Ly6vl
=scBy
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2BGTpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:45:54 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:52953 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756825Ab2BGTpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:45:51 -0500
Date: Tue, 7 Feb 2012 11:45:47 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mjg@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/5] Disable MCP limit exceeded messages from Intel IPS
 driver
Message-ID: <20120207114547.2a32fbfb@jbarnes-desktop>
In-Reply-To: <1328545032-21373-6-git-send-email-andi@firstfloor.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
	<1328545032-21373-6-git-send-email-andi@firstfloor.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EzMM+PpiXHXtM_4M2qmhbmL"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/EzMM+PpiXHXtM_4M2qmhbmL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  6 Feb 2012 08:17:12 -0800
Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
>=20
> On a system on the thermal limit these are quite noisy and flood the logs.
> Better would be a counter anyways. But given that we don't even have
> anything for normal throttling this doesn't seem to be urgent either.
>=20
> Cc: jbarnes@virtuousgeek.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Yeah looks fine.  I think I queued a message reduction patch awhile
back too... not sure if mjg saw it or not.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/EzMM+PpiXHXtM_4M2qmhbmL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPMX9rAAoJEIEoDkX4Qk9h+JEP/1fQHfUTOiqhj6+jDTQE7+1M
zUDvvOPAPiV+LLsHvDjl6IZ4zsFlxkWaimz1PvxR+mQeHCZca9ePP2wxlnBt6Lcq
7tpUoHruCn3W5I+AeMU9gFQND9p2kqTxBlrwffmtT7Ei4BHm9k1YW+TvV3zSW2fq
u/yBt1iFn1BqBDV7qcjtyViy6GFUMCnD+vy0ekmuQ+9uFrhCxVkLEozteUrHrgVs
mGqMLrcTEcH5nO79MPONAk6nhuqbn4DryCuBQNK4nSt6XdX3eHOxr62GYOS6srZQ
7LFx2b/o+c3EADrfnONGS2OekAIVe217I7Kh72A3yKZkzMHdCcpfzxN7DL90L+zW
XocV1HWMk77Gp87tvzPtAPN/mHzzoNF48IJ4UA6G3QVLzWgQHjKWGBJeE3yroneq
+d6S7c7Z+lMF29Yycqk/FyvwvVm1k9WpQtYLfR9w4FRCaazXsb5PmxeuarlUmQ2T
f6dmEWwHzQLD/e5YgAwPgULE7b8mtqZrlfhxjotapV5nuEBZoVsn0fy/hvCG3gXo
eb4KeLKJdfBo0v+A2I6w1CM7LhuHSL+e3P0vg7PDZUeeb1AKPJiuPhIBn8ldfGjQ
o7Yn1jVDNw82y+lQWtXPaedkz+QWk5x9apb4m4duNEWJ9mYA5S1H49OoeA965lTo
gYUpAIAYjJKgtgZJ52ZA
=1/jC
-----END PGP SIGNATURE-----

--Sig_/EzMM+PpiXHXtM_4M2qmhbmL--

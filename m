Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2DSACi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:02:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab2DSACg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:02:36 -0400
Date: Thu, 19 Apr 2012 10:02:28 +1000
From: NeilBrown <neilb@suse.de>
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: arch/86: AVX RAID5 xor checksumming v1
Message-ID: <20120419100228.05112e58@notabene.brown>
In-Reply-To: <1334789928-7238-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <1334789928-7238-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5GfBOCnFApxfNP.q=xmOMiN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5GfBOCnFApxfNP.q=xmOMiN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 15:58:47 -0700 Jim Kukunas
<james.t.kukunas@linux.intel.com> wrote:

> Hi Folks,
>=20
> The following patch adds an AVX implementation of the RAID5 xor checksumm=
ing
> functions.
>=20
> This version differs from version 0, in that it:
> 	0) checks whether assembler supports AVX
> 	1) replaces __attribute__(aligned(32)) with __aligned(32)
> 	2) adds do/while(0); to macro blocks
>=20
> Based on xor_speed, the AVX implementation appears to be ~32% faster than=
 the
> SSE implementation on my i7 2600:
>=20
>         generic_sse: 15088.000 MB/sec
> 	avx: 19936.000 MB/sec
>=20

Applied, thanks.
(though I remove the blank line at the end of the new file - the voices made
me do it, I had no choice)

NeilBrown

--Sig_/5GfBOCnFApxfNP.q=xmOMiN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT49WFDnsnt1WYoG5AQJkYg/9HxGzSukJhYeZHX2LRUdk0+J5X0AkwmtT
btBs6cBitEEebc2p4HF6AzZFuoIDg+X9WTEZWpX4/wWy0mFPTQ0M0WR6V4B1SrXz
iqfyx66wdWN84xW1hUfn220nsvaThO0MJsBxmExF3+hUwVqy/tKlpgUkgKBJz4mc
ZwjHHT89qIwypOquPc3nF+zGqfopgitbVBw4UR+1uMYHQ4aarbWsRnwGVwG8EnwS
gdxt2hV07v4GbHQA9r3uvj7JzGjKoWULPMWK/+CTwE/0KQH+idoK3DQtgOEAet3B
L5v73pzVbQwdWH0dPrSPXANQoQtDYaXGfgluazNyAWVXseKQdCc4itBj9B46gkId
P7AvjWXvamuTV/gifxrSGHX1rZfbR6QH0BP/emGJg3APGHehzaKJIGfs6VNOoa6u
dJ0SY6hXTCcuIZB9934a3RwgkUsvZL9kJP2E6rIDHDu4r1c7tJCBVZYtjapSqicd
+11GHBpYZq96YIpWNUJUTPIPNcXPCwRdTKKNm1FhIG5QOd9/hxHCL8KbMR3nGi2s
ubTHdKydtCazAX6iRHf7Pzt2T3EUN5hLRCIhGbIUuUgRoNDc5kJe6R5f4WROzFJf
5JRTw4qbWcYV21TPKSI0HWp5QXFrn83o0lRYEHcpJq2ng8UgRfZst3OTPNXJL5dy
3/ypCnGb8w0=
=g4ce
-----END PGP SIGNATURE-----

--Sig_/5GfBOCnFApxfNP.q=xmOMiN--

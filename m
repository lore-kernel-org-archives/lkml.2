Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2B0C6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 21:58:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53477 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2B0C6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 21:58:50 -0500
Date: Mon, 27 Feb 2012 13:58:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the uprobes tree with the tip tree
Message-Id: <20120227135839.df169a9126ce5a8f2b53c718@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_13_58_39_+1100_YXXBM8TKEBJRDcd="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_13_58_39_+1100_YXXBM8TKEBJRDcd=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

Today's linux-next merge of the uprobes tree got a conflicts in various
files between commits from the tip tree and commits from the uprobes tree.

It looks like a later (and different) version of the uprobes patch set has
been merged into the tip tree.  So I have dropped the uprobes tree
changes for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Feb_2012_13_58_39_+1100_YXXBM8TKEBJRDcd=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSvFfAAoJEECxmPOUX5FEHGwP/RRGZduNKJNDPw/Je58oQgFs
GkvA3TX8ag1lQVdkPeAwcXCj/2WR1vZn2B40qxM+909xDmE+pCBtgWBVwZxYTHGs
jRO6pxfEtZPRWPsOeHNpzv/2rk/Gk0bo346kvDFFgs3VFTeei3Cppx+a9I4h66RL
w+x2Vc9pzeJw0QIzYBJhUfRSh88h0shvaUkioftTSCg5SV3NEjzooLV80l2U9fwh
nYY0Twfoq9odvixxZZpawWIuPW5HhhGH4hxLKxLLZXRX/ELfSgrX7hJbI7NVuIdo
GzGftInoCHx19zkQS4+GcywpqbezGL2qPzkZzD0FZxtVrSLAKKWaHfcHXu1xdQ/1
ipCW8HoCEIBlpLu8sDSMM8kEo+UQE3NChab079GWc5OEzpyhqwaV+jF7ryAfSvDF
jqcI59bRI0NpfpoCxG+WK5BUEVdnwFcAx0nnov6aXQQlVNggFcno03VowI8ERLwO
EtUlJYRWkxfI2Ezb4BaLMcjcwp1w3Kj7MdMz7V6K/2TYigUFyO9djNcSchhneg9T
J+ww+oF9xLtCT5nTybbsgElepaPDLhJ+atksLw0eEMftRMqJZ8sK+cOKVcPOyJEK
xvcrCnipaw9ACzJS4aocCUfhn2ZxYtoRwOjRE2Pez+XcGP+kiV8VnrrDhGytvwJ/
3xwpicaaCgTXDaDobI1y
=QuFf
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_13_58_39_+1100_YXXBM8TKEBJRDcd=--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366Ab2CUNxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:53:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40403 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965124Ab2CUNxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:53:12 -0400
Date: Thu, 22 Mar 2012 00:52:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: linux-next: manual merge of the oprofile tree with the tip tree
Message-Id: <20120322005259.633e2ab7b27e646fe3d03937@canb.auug.org.au>
In-Reply-To: <20120321123348.GJ16322@erda.amd.com>
References: <20120321163151.83cad17d5524424938f7576c@canb.auug.org.au>
	<20120321123348.GJ16322@erda.amd.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_00_52_59_+1100_g6dcvKQ91j1kLVJI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_00_52_59_+1100_g6dcvKQ91j1kLVJI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robert,

On Wed, 21 Mar 2012 13:33:48 +0100 Robert Richter <robert.richter@amd.com> =
wrote:
>
> Yeah, the trees are totally different now. Removed my tree from
> for-next.

OK, thanks.

> Btw, please switch my for-next tree back to kernel.org:
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next

Done.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__22_Mar_2012_00_52_59_+1100_g6dcvKQ91j1kLVJI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPad07AAoJEECxmPOUX5FEq40QAJ4cpN3NvLPNhqo/LgnhKJA9
aigJLAc+juXKFjKFG7NdWnlO337EtPv7K4qiW7g+jt/iHodoDS6bWTIrRuED3h9i
vW+64TfYDzANBsV+/NoLqhUxfau+CAT5pVumB0go9IK2/hWQzDb4Z9BuMAccEfwa
30M3ow7h1tV9YFlV2ZQP+FyKgt1siz4iZG9Ka8leBI8WmqiBzlNsQKllhJ6jpLop
BDYsf3hdFKFVGjNeowzaynGY+rYuBNikuoQ3pKra5KL5O/0JQXABA+0NMnya6gnT
92W/YyuHDX68XC/D/5n5CRg1O7gkIZ6P7wX2pWBnm8WjrRFCl/1niHIAUsKH0+Pj
+FCcR1dVRjPBgQtctNJqTs+jsw3OdJfk/5Tw6oywI+Zn5Nh29TXJGKPCOwW6a7nN
p0AEzbDRr3s8quMG/NrqI/CfpOxJ3631T8HfudyxS9dcHL2NNX6fA8YAJaeElFpB
al+jIPK9uMNRoPxmWWMwNF5/Z6lqlWH0JIG5ud1SB8qIUgjeCtZxzB5wwC05WPKr
glgOk80HnwAzjU9u0OrPD04TlBw/AjRuAiRYi8pKimlpZEM3RuN1raVkfjaJBoZM
7ooWSbOsTokilzL6e1yzkclMKv1FTOo+do10gIjT/MDQggZM+qesf/LyQBNr0r5a
OzGo0ex8qRuyLxtet5Ni
=Sjt8
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_00_52_59_+1100_g6dcvKQ91j1kLVJI--

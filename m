Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2CZVob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:44:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54985 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2CZVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:44:29 -0400
Date: Tue, 27 Mar 2012 08:44:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the battery tree
Message-Id: <20120327084414.dacbf074e0f4ddd65ff3ecfb@canb.auug.org.au>
In-Reply-To: <20120326161132.GA6430@lizard>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
	<20120326161132.GA6430@lizard>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Mar_2012_08_44_14_+1100_BMU5Ak/X.pQ+qRby"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Mar_2012_08_44_14_+1100_BMU5Ak/X.pQ+qRby
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

On Mon, 26 Mar 2012 20:11:32 +0400 Anton Vorontsov <cbouatmailru@gmail.com>=
 wrote:
>
> I pulled my current battery tree into next-20120326, and I can't reproduce
> the issue (using allmodconfig on x86_64).

I have moved the battery tree to after the mfd tree in my merge sequence
so we will see if that helps.  I really hate having ordering dependencies
in linux-next (since they change over time and people have to remember to
tell me and to send stuff to Linus in the right order).  Also, it means
that you are not testing exactly what you are sending to me - I assume
that your testing must be including the mfd tree somehow.

These sort of things should be fixed by having the common code in a
separate (stable) branch that is merged into both trees.  Or in some
cases by merely cherry-picking a very small number of commits from one
tree to the other.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Mar_2012_08_44_14_+1100_BMU5Ak/X.pQ+qRby
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcOMuAAoJEECxmPOUX5FEZ04QAKVaiJMxkYW/Kki/P+axrMYk
pQB6jF+nEtmS+BBoZad/REu9uKrT3UV6CRHg/dereMXp8fcQ1eCh3Yek39z3KcIT
GXietXiD7xKCdtsWwCxqBTeoZOz9ySQgKH2gOfpEKnvGYWbqZhx+1oMSelH6praI
EHEZp/nV9YY6zE1Fi9GSR9BQTEzcT2Av31WbXmIoeTX9jj9tkiKx+3gNyBqufUL6
2UgWu9q8blJ04m1rtvANkL8pXmkQaayvTafagULzVocWgRkGZOYkqAys3ob5xfc6
5il8TgGOn+oWIVjusbCk97f1Uiz/PsndOPX4o+nhfAq2Z4RHda/p3AVaLEmr6/Je
knlkReoRWlgnsOG8YohP5jjeMk/+MkjKXzN4JiTZ5/V8LX9NpY20Wa4bc7m0cErW
6gJSt1+1oo00Uooz3l3liU66A1jy6KQwlb2moJCRUyW9gDXBthTj1jO4QV33xKSo
1jUF4Jgt9Cl5mQCgaRsoZyOD6Vb5bUldA4HdkCJ7Z3NxV15UXer14tiifG/ZqJlB
hv0/Yi268NcqxcwI19A/UBLiNYT4aMn5MkUjt+BgBGyN7ci6v76AhGCSX7e0eQVo
OFc1eQ58VF73i7VHaXLoRXuRdvi52rV9dh/CqLJ5FmHEdqbMip4V6CFXkcKkBH1B
SZk8BNlmWpj1SlOUBcd+
=gf/u
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Mar_2012_08_44_14_+1100_BMU5Ak/X.pQ+qRby--

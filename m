Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2IYVzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:55:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39072 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2IYVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:55:34 -0400
Date: Wed, 26 Sep 2012 07:55:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: Matthew Garrett <mjg@redhat.com>, hpa@zytor.com, keescook@chromium.org,
        tony.luck@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        cbouatmailru@gmail.com, ccross@android.com,
        paul.gortmaker@windriver.com, maxin.john@gmail.com,
        matt.fleming@intel.com, olof@lixom.net, dhowells@redhat.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        khalid@gonehiking.org
Subject: Re: [PATCH -next v2] Shorten constant names for EFI variable
 attributes
Message-Id: <20120926075528.e497436227403ecaf1b845d3@canb.auug.org.au>
In-Reply-To: <20120925154100.GA13412@ldl.usa.hp.com>
References: <20120720220841.GA32642@hp.com>
	<5009D770.1050905@zytor.com>
	<20120723132656.GC21495@srcf.ucam.org>
	<50117E40.8090904@hp.com>
	<20120726173332.GA19851@srcf.ucam.org>
	<20120925154100.GA13412@ldl.usa.hp.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Sep_2012_07_55_28_+1000_l.x8XiSImdyIr9BF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Sep_2012_07_55_28_+1000_l.x8XiSImdyIr9BF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 25 Sep 2012 09:41:00 -0600 Khalid Aziz <khalid.aziz@hp.com> wrote:
>
> Replace very long constants for EFI variable attributes with
> shorter and more convenient names. Also create an alias for
> the current longer names so as to not break compatibility
> with current API since these constants are used by
> userspace programs.

Why do this?  It just looks like churn for no real gain.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Sep_2012_07_55_28_+1000_l.x8XiSImdyIr9BF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYihQAAoJEECxmPOUX5FEjZ0P/1aRRnx5Ii4AVWZOTefjp7Xv
20xSVJEBhGE8na7kfAoGZHUH8yYxjk4y/XXMEU2vTwV8odB3q/zrIvSn7Hg3UtT+
AJbzUO4r5qv1leu6sHwb4pNzdK5h/yK8WwhVAMUGCajMunyot8xFJV6TX6h1VLfb
ce9h6kFfm/SDzgHMZL0RHbFAQNNm1uZztoty90eIzCJel29KFG0409XWFCU53Vz8
kixL7OwynjkQnnlnucnepsvUoBse2ZfulyE/l5JoL7urMEd5ZuwbQaWg21StlvfL
2Cs/OdDP24WxApgnQnRKJht4dixMB6BQG5gljZLd6gUAyC0+4Z98tYDq+KdAeu8p
93H8P9RG6PoSL0k2QpumD6Ayik68u1Vxsr4ectCIb3xZ0nrTtaumB9/mOua0WhQ0
//WfaLmlOvFx6DVs4m5S0ah8znlfgbqngAuVPj+BWgaXI5qiZw0EY4np6xmJ3MWZ
bbl6v3LBfxwfcrDZeMMFWqQlWtQrV+8gkV13eDliOt/UjGgfaIFTMfCq4ymryf81
9v8snzENGWMQ7tuTI9b2x5T7a+f2o0PeMHrH0oYdu14xaKLQn6hLRZmNyUnZRnZU
KE5Va+L0tgkaQw1Z8rBZfmkQGsGOtjzjqcKtsZ9ZoXwCsBCALblcUP2DLYJE3uGh
Mtbe+Fh//aL37Yzqby4a
=ymgV
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Sep_2012_07_55_28_+1000_l.x8XiSImdyIr9BF--

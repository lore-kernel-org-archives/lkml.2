Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3AHLg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:36:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43466 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3AHLg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:36:56 -0500
Date: Tue, 8 Jan 2013 22:36:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: comment in commit in the slave-dma tree (dmaengine:
 dw_dmac: Enhance device tree support)
Message-Id: <20130108223645.257ef71445b1c5ee6773938a@canb.auug.org.au>
In-Reply-To: <20130108081735.GB19691@intel.com>
References: <20130108093557.8a29d4a04b95702fc59790ff@canb.auug.org.au>
	<20130108081735.GB19691@intel.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_22_36_45_+1100_0wDpCxfHuK_Yb0RA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_22_36_45_+1100_0wDpCxfHuK_Yb0RA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On Tue, 8 Jan 2013 00:17:35 -0800 Vinod Koul <vinod.koul@intel.com> wrote:
>
> I think I was trying to remove it. Anyway I have changed the commit to re=
move
> this and also another instance. So you should be happy about it :)

Thanks.  I would have been even happier if you had just added another
commit that removed them :-)  But I shan't be churlish.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_22_36_45_+1100_0wDpCxfHuK_Yb0RA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ7ATNAAoJEECxmPOUX5FECjYQAJsqR41FqAxvwwG6ILiHSigk
LFrb548nCZt/s8Fb04tR4IpikAUmKTEz5DMKs2w9mckgC/RjX9TAuhpXEPjIgYRl
0jNr2ZaVbnz6yIj0BIvQKd44OhyaiLKpwjQmjvlND64lC1DB824O1HEjENoo8AtY
9yRJU0buR89NeKPxbtr3tH2BE6+J4qxKIWYfh4BR/dJ08PRRLK3bxmncl75GRhKd
HipU6cQSnmwzniRp/G/yXso1pcAwgSo2jl+U9jUsIMpiOG1Q6UtHv42zZSQ89JMQ
mlhRmXnDYeAQukSDC+Fgm9Iw2OGosIuJNtQSSH6s/h0y1qiSCgOp4jRPbScfEjoG
HNzWZ9vHr8HNRAGy/+tiC12glTb9O6lH/XysVVcqka0QvQ1s74K1vcrc1tTn5fox
YQMEQu9uI5iomIztsCmYARJpY3vqydXwOjAaKHy13KYThHGYUXcEBwTsCeDMKPtK
CyMjfnfwbNRBqmD2Iln3x7R0/hk01hkv6GrPYKkP+DcpNbXvN+IpgXtaTiZSkBo5
tDICs2ow92mic9lG/VseQpflDe+1aTbQNS9V2dEa9/+Gcpa1I3LBJOIibLP0rElE
0QefkcwdXLU9p59Y9zRtI32rno4yRBUemFzmUCLsUVQ8ogvBgsSpdMZA3kYcG/Xk
ZsnxAMsji78OWt093xR0
=ebI9
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_22_36_45_+1100_0wDpCxfHuK_Yb0RA--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069Ab2JKR53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:57:29 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57061 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2JKR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:57:27 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: kswapd0: wxcessive CPU usage
In-Reply-To: Your message of "Thu, 11 Oct 2012 17:34:24 +0200."
             <5076E700.2030909@suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <507688CC.9000104@suse.cz> <106695.1349963080@turing-police.cc.vt.edu>
            <5076E700.2030909@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1349978211_1985P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Oct 2012 13:56:51 -0400
Message-ID: <118079.1349978211@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.50770864.0029,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1349978211_1985P
Content-Type: text/plain; charset=us-ascii

On Thu, 11 Oct 2012 17:34:24 +0200, Jiri Slaby said:
> On 10/11/2012 03:44 PM, Valdis.Kletnieks@vt.edu wrote:
> > So at least we know we're not hallucinating. :)
>
> Just a thought? Do you have raid?

Nope, just a 160G laptop spinning hard drive. Filesystems are
ext4 on LVM on a cryptoLUKS partition on /dev/sda2.

--==_Exmh_1349978211_1985P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUHcIYwdmEQWDXROgAQJyShAAgujgX/Bqb0muTiM7zQML12rouyjrzGJ9
IrOmR/ckASQiO7mYpGJscQYv/jGSYB248K9ethpm/4lMFuRj/1vXv3se7jhzuwzG
lBa7CQ43+1tq7utPhRBcGF6uvo/2Ofep078TxX5wp4w5tfma8QamH2Ol7kDxnuMj
TYlhRYyNXVHcTAfVGDghVsY3PBjx8xkDoxNiddkYUPmdM+Ul3EDQerJYElkbks0q
8lCUhCk7RyG7UfD/HdmxSdhpXC937cqvHWIfR2lvKsGV5TOaYGxpvZUo57qp1Ls7
iQTJ5tqZAKelEiUoC+lgsPxzxh4oMMD65Iv7yPBnRrQxnQ4E2RfocUfwJZ4sTIxg
MYm+I4VXoIIOEurvyx3xj/1iBEOFrW2YmLCbFxSOXJaAJn7yrhcCNeeBTII1lwrL
zKPluU7EcjI2T7PIqVk8nUjTrK1kEYgyC+MR1RVbsFdlyjlRyVzhdCYQ0kVoAuM7
qMKGkvj/SRyLxkoWpK84/xn+Skcof4yPpz9DxGtdET2SDZQ6Qajmve6P4wNehkF+
U6R8lDkxEqHqgSO8xVkIVOwfF1MADByPCmcNfepep5kQY5wTuOM+3b15L1saPu54
um5CXS+Fifd4WF65MJ8E//yF1LiljC1tZVdHHD580B9XbvO1oUagnMp7lBNLBFXB
FtnM3eLt06I=
=0Zb8
-----END PGP SIGNATURE-----

--==_Exmh_1349978211_1985P--


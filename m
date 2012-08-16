Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab2HPNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:25:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:33328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab2HPNZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="asc'?scan'208";a="187223689"
Message-ID: <1345123814.3393.237.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/8] exofs: remove lock/unlock super
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>, bhalevy@tonian.com,
        jack@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
        adilger.kernel@dilger.ca, tytso@mit.edu, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Date: Thu, 16 Aug 2012 16:30:14 +0300
In-Reply-To: <502CF259.9040300@panasas.com>
References: <502CC4AA.6040702@gmail.com>
	  <1345119652.3393.220.camel@sauron.fi.intel.com>
	  <502CE840.4060802@panasas.com>
	 <1345122611.3393.225.camel@sauron.fi.intel.com>
	 <502CF259.9040300@panasas.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rht197DkSjhl0XuM7lyi"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rht197DkSjhl0XuM7lyi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 16:15 +0300, Boaz Harrosh wrote:
> There are some optimizations I can do here, but lets for now just do
> the sb->s_lock thing, and I might decide to completely revamp the
> all thing later.=20

OK. But I guess an exofs-specific mutex could be used instead. We do not
have to depend on 'sb->s_lock'.

--=20
Best Regards,
Artem Bityutskiy

--=-rht197DkSjhl0XuM7lyi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLPXmAAoJECmIfjd9wqK0DsoQAJLvs5AYeSq5r3yu/9Avjugv
/GhIa0D79PoTTwMod13al1NRHlWgZtBbzruXWIiPDbXlih1TLDqDiLr7Zqc0mrT2
DnPDkcswtA/RFx0UqIJ9HixA/g9lajnx0Zy47IvptiiKytTlOsTKsLT/kl4O/Ng6
S3yji1JBXjoFqvMKBtT57jGV8xZr2ayy2bgjrixIlUlmYEtddnDDxhHBKfeddqe5
Oq9BaeKUh7iOvAmIMZvCi6l3OM6Rygd6spz/3Y/vk9Vr8D0opvdujTDu6bx908yi
eStwKXdKR22hmYIStYjuhTYGXzxnqNyCbNl3pV3Min4SYsT3mOppaChOPmcJRySH
nvTXj5OVZmeJgTpz/jiFCDrhDOpjahbRGBO+vh6+PQH/FYPbw5hJab++EALPn1En
hnSNBIomesGVOhNpxpGnQLXbVDiY/1HdS/Hz0MZsOip4FI1jb2qU6nkZV/8oAYID
YeyUPYYbHQ50iFt8sIF/Nkbau86Gs14QCecNOwsvZhYSdiAROEuwDQS1X5vC/Ki0
TtEVEAE4gPcIZKVSXUEboQv2n2fBpQCNGiAAzg8jXzgQPb07789bMWH2WblY7QgZ
+XT6YQ0SGp2vw75N/bHw0YGsngUhO8ZircmyTPF6/9lk/oyFT6e/tuHnyGFJYIze
QTtHfSZ+ORlBY7QJUf4t
=rX67
-----END PGP SIGNATURE-----

--=-rht197DkSjhl0XuM7lyi--


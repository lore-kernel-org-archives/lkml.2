Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0ERHzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:55:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53656 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab0ERHy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:54:58 -0400
Date: Tue, 18 May 2010 17:54:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-Id: <20100518175451.a01e314b.sfr@canb.auug.org.au>
In-Reply-To: <m1wrv13dam.fsf@fess.ebiederm.org>
References: <20100518164520.7e9652b1.sfr@canb.auug.org.au>
	<m1wrv13dam.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_May_2010_17_54_51_+1000_F8RrUVjRw0N5MMX6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_May_2010_17_54_51_+1000_F8RrUVjRw0N5MMX6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, 18 May 2010 00:00:01 -0700 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Stephen what is the easiest way to get a copy of Al's tree so I can take
> a look to see what needs to happen?

It is here:

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git#for-next

[The latest list of trees included in linux-next can always be found here:
http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dblob;f=
=3DNext/Trees]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_May_2010_17_54_51_+1000_F8RrUVjRw0N5MMX6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvyR8sACgkQjjKRsyhoI8yWpQCgu9PMSzawtRcouXj2XnfP923d
6gYAnjahpH+do0IM4N8uV2nq1lEysOHD
=EdHF
-----END PGP SIGNATURE-----

--Signature=_Tue__18_May_2010_17_54_51_+1000_F8RrUVjRw0N5MMX6--

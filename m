Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1LVTwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:52:47 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56624 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1LVTwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:52:45 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Joe Perches <joe@perches.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Steve Wise <swise@chelsio.com>,
        linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
In-Reply-To: Your message of "Tue, 20 Dec 2011 18:35:50 PST."
             <1324434950.14214.3.camel@joe2Laptop>
From: Valdis.Kletnieks@vt.edu
References: <1324430940.2844.144.camel@deadeye> <1324431127.2844.146.camel@deadeye>
            <1324434950.14214.3.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1324583550_2451P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Dec 2011 14:52:30 -0500
Message-ID: <7831.1324583550@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4EF38A7F.0176,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1324583550_2451P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Dec 2011 18:35:50 PST, Joe Perches said:
> On Wed, 2011-12-21 at 01:32 +0000, Ben Hutchings wrote:
> > Physical addresses may be wider than virtual addresses (e.g. on i386
> > with PAE) and must not be formatted with %p.
> []
> > The resource could alternately be formatted with %Pr.

> Probably should be unsigned long long

I don't have a dog in this fight, but the %Pr sounds better to me.

--==_Exmh_1324583550_2451P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO84p+cC3lWbTT17ARAlyQAKD+hI0oj4y43ZHN4rB1YX9BZnXJIACfZqrh
D0CWeD2hmcN0W+pDpL0Owmk=
=HFH0
-----END PGP SIGNATURE-----

--==_Exmh_1324583550_2451P--


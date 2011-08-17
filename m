Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1HQXcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 19:32:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46653 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1HQXcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 19:32:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Layton <jlayton@samba.org>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes with linux-3.1-rc2
In-Reply-To: Your message of "Wed, 17 Aug 2011 15:16:40 EDT."
             <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan> <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
            <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313623869_2796P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Aug 2011 19:31:09 -0400
Message-ID: <26399.1313623869@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E4C4F3F.0072,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1313623869_2796P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Aug 2011 15:16:40 EDT, Justin Piszcz said:

> Tried with linux-3.1-rc2 and:
> 
> You don't even need to get a successful mount:
> 
> Does anyone know if any kernel supports CIFS w/out crashing? I'd like to 
> backup some CIFS shares, thanks.

3.1.0-rc1-next-20110808 is talking CIFS to our NetApp without any complaint.
Not heavily stress tested, but it mounted, I can see files, I can open files, I
specifically tried 'df' and didn't crash.

So I'm guessing there's some subtle difference between what my NetApp feeds my
laptop over the wire and what you're seeing from your Windows box?


--==_Exmh_1313623869_2796P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOTE89cC3lWbTT17ARAnGZAKDjNIGBTZpkursKwWIiwlXHkk3D9QCfel2r
Q1bFNvO338NdGfRmwnWlhfk=
=+vGx
-----END PGP SIGNATURE-----

--==_Exmh_1313623869_2796P--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1AGRMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:12:50 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38941 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab1AGRMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:12:48 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Joe Perches <joe@perches.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
In-Reply-To: Your message of "Thu, 06 Jan 2011 13:38:38 PST."
             <1294349918.12561.142.camel@Joe-Laptop>
From: Valdis.Kletnieks@vt.edu
References: <20110104055900.GA5062@bicker> <20110104163836.GA30317@fieldses.org> <20110104164414.GX5875@const.bordeaux.inria.fr> <1294160834.6617.51.camel@Joe-Laptop> <m3fwt7i740.fsf@intrepid.localdomain> <1294249529.6617.118.camel@Joe-Laptop> <m339p6p5zo.fsf@intrepid.localdomain> <1294336674.12561.81.camel@Joe-Laptop> <m3r5cplr2m.fsf@intrepid.localdomain> <1294347753.12561.106.camel@Joe-Laptop> <m37hehloon.fsf@intrepid.localdomain>
            <1294349918.12561.142.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294420352_4860P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Jan 2011 12:12:32 -0500
Message-ID: <26590.1294420352@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4D274982.003C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294420352_4860P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Jan 2011 13:38:38 PST, Joe Perches said:

> http://swerl.tudelft.nl/twiki/pub/Main/TechnicalReports/TUD-SERG-2009-008.pdf
> 
> RQ2 Are files or modules with a higher violation
> density more fault-prone?
> 
> This holds for 10 rules in the standard, with some reserva-
> tions. There is no reliable prediction for files without ac-
> tive development (no changes) nor for files without viola-
> tions. Also, the observed relation becomes less pronounced
> in time, as the number of registered open faults decreases.

In other words, code not written to style is like finding a brown M&M
at a Van Halen concert...

--==_Exmh_1294420352_4860P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNJ0mAcC3lWbTT17ARAnojAJ0USWFnk/6547OkW2hR9BPzhuyGTQCdHVTW
jl2gs/LWC3gRjWgoZbkFafc=
=Za/k
-----END PGP SIGNATURE-----

--==_Exmh_1294420352_4860P--


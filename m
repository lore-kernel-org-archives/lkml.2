Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2GJWcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:32:21 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34943 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab2GJWcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:32:18 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Meelis Roos <mroos@linux.ee>
Cc: Dave Airlie <airlied@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: 3.5-rc5: radeon acceleration regression on Transmeta system
In-Reply-To: Your message of "Mon, 09 Jul 2012 14:30:40 +0300."
             <alpine.SOC.1.00.1207090051120.3699@math.ut.ee>
From: valdis.kletnieks@vt.edu
References: <alpine.SOC.1.00.1207050956300.515@math.ut.ee> <CAPM=9tyo69+8QTCKMDCOTzWT2gR+uXkynOny85PaQ_nCYNMGAg@mail.gmail.com> <alpine.SOC.1.00.1207052224340.19147@math.ut.ee>
            <alpine.SOC.1.00.1207090051120.3699@math.ut.ee>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1341959529_2260P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Jul 2012 18:32:10 -0400
Message-ID: <60495.1341959530@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.213.48 mail-yw0-f48.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4FFCAD6F.0079,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1341959529_2260P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Jul 2012 14:30:40 +0300, Meelis Roos said:

> It's actually more complicated than that. Old kernel images started
> misbehaving from around 2.6.35-rc5 and any kernel older than that was
> OK. When I recompiled the older kernels with squeeze gcc (migh have been
> lenny gcc before, or different answers to make oldconfig), anything from
> current git down to 2.6.33 is broken with radeon.modeset=1 and works (I

What releases of GCC were those?  I'm chasing an issue where compiling
with 4.7.[01] breaks but 4.6.2 is OK, wondering if we're chasing the same thing.

--==_Exmh_1341959529_2260P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT/ytaQdmEQWDXROgAQLoSw//cH91cXsMLnOFek0IkKz8GoTNPtPmV88i
fODIu8DfpUaUqD0+icvT4EiV+DNfjZF/NBxHLfWrRDXtF5Q6qQ0u0RZgRcVoWsWp
rQDns+g1KtzxvNzHcUpLpqh+z8/LMr/QPhNd+OiYSp1o0Ot6wkOrIfNwhD9GxyKw
egdHEPt91cJ9Nb5pv02objyfTTEej+24l/DKROo1U5tnV6KdBlDBFSzXcDwyykkL
ki89mdNiMQciUvUdZhQop7TXuOgWRYp7ExOXNevEDq1qIKdPVh3OnAh5TOWPMdfC
p/29usbtO91XAxh65U3t4hhRaXyfHcTJ2aMls8KmjGcNR8uPryby8STVd0N/3J6z
MilCP1JpCWAElI8G2pfCDsEm1mM4FWh4bq4ti8i1S1F1Y2vUzxLrd63pqaHF7oBv
ow/hrMvbXF3Pzh3wk4z6rAf3UKRkkFNgA2avO2jDPMn9WWkU/dREZnZEK1jo1aCw
U7I4WjzXuOVIY+XHINSzpphQnHQrMJBA8Td4U8lCVPkPHbUNUpLJY7Ayann+RhCp
Kz7PSi6uMMUFARHDpXQKvMJEflEqnEhGgGp+X/YJ/cAUtC+VLXdKxAGe+Co2LyJ2
RtSSRi2t3NEyzpHheLqwRwotMLTXYs2KQKqu24wqc2VOkCJCoqn35TNxOq+DurdP
dx0dLBhX4TM=
=OWDD
-----END PGP SIGNATURE-----

--==_Exmh_1341959529_2260P--


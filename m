Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966520Ab2EOU0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:26:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51542 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169Ab2EOU0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:26:33 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
In-Reply-To: Your message of "Tue, 15 May 2012 14:35:53 +0300."
             <9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com>
From: valdis.kletnieks@vt.edu
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com> <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com> <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com> <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com> <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com> <1337077714.27694.21.camel@twins>
            <9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1337113581_2773P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 15 May 2012 16:26:22 -0400
Message-ID: <54348.1337113582@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.161.180 mail-gg0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4FB2BBF9.001D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1337113581_2773P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 May 2012 14:35:53 +0300, Pantelis Antoniou said:

> Thermal management: How to distribute load to the processors in such
> a way that the temperature of the die doesn't increase too much that
> we have to either go to a lower OPP or shut down the core all-together.
> This is in direct conflict with throughput since we'd have better performance
> if we could keep the same warmed-up cpu going.

It's not just "temperature of the die".  When you have multiple aisles of 42U
racks full of servers, you often hit "must keep average total BTU load per
server below X" constraints.  There's plenty of colo's that are only using 40%
of their floor space due to cooling constraints (you may be able to get the
power company to pull another megawatt of copper into the building, but then
you need to find someplace to put another megawatt worth of cooling).


--==_Exmh_1337113581_2773P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT7K77QdmEQWDXROgAQLyow/8DjWVxCbuPMUeX4hu2yn7ZqfmF7bTBdH7
v96Xg2Oieg773RDKf4Si6IGtX3xKSkkauNaVDzoG1xCYb138OyN1zwNb2uFmlh6f
JYBBwWsNrhidIzIN5SHz7tB4E/rxeGLdUkPBy7VMokYAJRFQHw4m2h4OVpENRtXO
qpv5ObnI5B6N6IWYihRtoGFDTfBhYDV4ef2ofChy8BIBu3Yh4O65T/geJfmdHrSj
sMxe81KnYI/ibSq5T+4+llq34HJ1ugMMZAS3TJpjth8Wm/zYpnJm+TK8OnmH3IBP
o92wWF5tQ+hMRqYuEgFQujbCnf79k5ix37cWx7s7cJh08Lpxjl2d4EfmwDMzm6Dg
p2xNUS0haHMPMeI2AbKI12D5qeolaGMKMXp/Yb5lwtO2RV+Q6eu1HTM0epj6x8Gj
i2ejMYbiaIWU/HsHPqWP5TXOAs1HfNcBrTU6p8dVNRTLVrlARDRXUbdRxny8GPqz
fEGBg8SmzPpzfQrsTL+fYXWsPFGCtNT1/7gcAnA2sQmcHUmazNj3VDhNhE2uSTb/
R1RASDu+gMROMM3eqd45KrPXqwFLDqmaLK/Qb+pRAEts54vaeR+1yLPCPqgl8Yvq
MRBDn0CiiBC4MtpKCQpy4lz+P0weRG3V4VXA3zDYwx1i5NtvRFrfoIazYjD4Q9Ss
l9Qt19hmWUI=
=/CsH
-----END PGP SIGNATURE-----

--==_Exmh_1337113581_2773P--


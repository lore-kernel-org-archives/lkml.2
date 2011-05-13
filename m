Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1EMDPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 23:15:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36058 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1EMDPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 23:15:13 -0400
Date: Fri, 13 May 2011 13:14:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: manual merge of the tip tree with the arm tree
Message-Id: <20110513131437.8999e8eb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_May_2011_13_14_37_+1000_r_HPsC+sfYUBuVw7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_May_2011_13_14_37_+1000_r_HPsC+sfYUBuVw7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/i8253.c between commit 3490f584b9ba ("clocksource:
convert x86 to generic i8253 clocksource") from the arm tree and
commitb01cc1b0eae0  ("x86: Convert remaining x86 clocksources to
clocksource_register_hz/khz") from the tip tree.

The former seems to supercede the latter, so I used the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_May_2011_13_14_37_+1000_r_HPsC+sfYUBuVw7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNzKIdAAoJEDMEi1NhKgbsJhoH/3+okqRPxMsLorUCYTFtt5JT
dQXaq8vjFciVHE9K9rX04n9OsZ8RrYbRYIWL0UUTNBE8Ww+Iioi3Iv4897LhbKIb
Di4kR7bf6qmHYPiRwxepRCq3H1c887EEOPSyWYeUzLPYda7JnOE8OWPAFUx/nx3j
WwaHRudKT120BpgshpRtT6u/me/coHRh4Z3QZs2p8TT3wr1/D5bCzGorL/9hfKyv
Xv3snUzK9DQrxynJJ1ZXNNILbl04I/hR06mWwyd4Qk5QhpvmI0UvswCNbogV2mV1
U2y2qX/ecGaRUesPQQS+qIh+xbK8HY2oeiYuH6AQbl2b1iIqm07T2G0HHieDvXM=
=Nsfp
-----END PGP SIGNATURE-----

--Signature=_Fri__13_May_2011_13_14_37_+1000_r_HPsC+sfYUBuVw7--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935168Ab1ETS0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:26:12 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48200 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934878Ab1ETS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:26:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jian Peng <jipeng2005@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant to AHCI spec"
In-Reply-To: Your message of "Fri, 20 May 2011 10:02:56 PDT."
             <BANLkTi=iNjWsaYCJqP057FkhAXtab5nS=Q@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <201105120025.34531.rjw@sisk.pl> <20633.1305565337@localhost> <BANLkTin7NgUMXSVyKn6P0TCrFZ5uaaRL1w@mail.gmail.com> <201105182144.37713.rjw@sisk.pl> <BANLkTimZ9pe-FhkJYHTG1Jx8MUPrMHSFbA@mail.gmail.com> <BANLkTim9_1Xt8oE4awbCO1iKUW96YUOv_A@mail.gmail.com> <10124.1305906020@localhost> <20110520154341.GL31426@htj.dyndns.org>
            <BANLkTi=iNjWsaYCJqP057FkhAXtab5nS=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305915959_2669P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 20 May 2011 14:25:59 -0400
Message-ID: <17610.1305915959@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4DD6B239.004F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305915959_2669P
Content-Type: text/plain; charset=us-ascii

On Fri, 20 May 2011 10:02:56 PDT, Jian Peng said:
> --20cf307f38f6d842a904a3b81730

> You are both right that adding this majic 5ms delay at this place should not
> be the final solution.
> 
> If this magic 5ms delay works on other affected systems, I plan to post a
> new patch that inside ahci_start_engine(), still perform same check, and
> show warning message if failed, but will set a flag, then still set START
> bit, and if there is such failure flag, add 5ms delay.
> 
> Valdis, could you apply the following patch and retest it?

I should be able to do that this weekend.  To clarify - should this be with the
problem commit 270dac35c26433d06a89150c51e75ca0181ca7e4 applied, or reverted?


--==_Exmh_1305915959_2669P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN1rI3cC3lWbTT17ARAholAKDXyBVpYZyAWJ8gqpx+ye9glWfMIwCeLr/V
nxlCRWYPv2DT4GrXxJPDTqg=
=pEhp
-----END PGP SIGNATURE-----

--==_Exmh_1305915959_2669P--


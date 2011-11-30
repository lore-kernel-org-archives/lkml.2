Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1K3X7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:59:43 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:54608 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1K3X7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:59:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: 3.2.0-rc3-next-20111128 lockdep splat during boot..
In-Reply-To: Your message of "Thu, 01 Dec 2011 00:17:18 +0100."
             <201112010017.19156.rjw@sisk.pl>
From: Valdis.Kletnieks@vt.edu
References: <23526.1322620187@turing-police.cc.vt.edu>
            <201112010017.19156.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1322697572_2875P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Nov 2011 18:59:32 -0500
Message-ID: <28342.1322697572@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4ED6C366.0053,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1322697572_2875P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Dec 2011 00:17:18 +0100, "Rafael J. Wysocki" said:
> On Wednesday, November 30, 2011, Valdis.Kletnieks@vt.edu wrote:
> > Seen this twice out of two boots while initrd was waiting for me to
> > enter the passphrase for encrypted LVM.  No idea *who* to toss this
> > one at - got ACPI, PM, SCSI and vtconsole all listed in tracebacks, so
> > I'm tossing this at everybody and hope it sticks. ;)
> 
> This was caused by one of my patches in linux-next and was linux-next-only.
> 
> I've already replaced the offending patch with a new version.

OK, thanks.

--==_Exmh_1322697572_2875P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO1sNkcC3lWbTT17ARApziAJ4xipIL+k6xkkdghUHcg5YTqMcCtQCeOWJ3
nb56IOqtP6pioI7BGhCg+c8=
=hnPv
-----END PGP SIGNATURE-----

--==_Exmh_1322697572_2875P--


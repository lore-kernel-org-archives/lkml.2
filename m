Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab1EPRD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:03:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58781 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1EPRDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:03:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jian Peng <jipeng2005@gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant to AHCI spec"
In-Reply-To: Your message of "Sat, 14 May 2011 12:28:04 +0200."
             <20110514102804.GB23665@htj.dyndns.org>
From: Valdis.Kletnieks@vt.edu
References: <201105120025.34531.rjw@sisk.pl> <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com> <201105132222.11582.rjw@sisk.pl> <201105132244.29605.rjw@sisk.pl> <20110514101807.GA23665@htj.dyndns.org>
            <20110514102804.GB23665@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305565337_2487P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 16 May 2011 13:02:17 -0400
Message-ID: <20633.1305565337@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DD1589C.009F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305565337_2487P
Content-Type: text/plain; charset=us-ascii

On Sat, 14 May 2011 12:28:04 +0200, Tejun Heo said:
> This reverts commit 270dac35c26433d06a89150c51e75ca0181ca7e4.
> 
> The commits causes command timeouts on AC plug/unplug.  It isn't yet
> clear why.  As the commit was for a single rather obscure controller,
> revert the change for now.
> 
> The problem was reported and bisected by Gu Rui in bug#34692.
> 
>  https://bugzilla.kernel.org/show_bug.cgi?id=34692
> 
> Also, reported by Rafael and Michael in the following thread.
> 
>  http://thread.gmane.org/gmane.linux.kernel/1138771

This also fixes the issue I had with a 10-second pause on my Dell Latitude E6500
laptop at boot while detecting the CD/DVD drive.

--==_Exmh_1305565337_2487P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN0ViZcC3lWbTT17ARAlsZAJ91zKbQW9Gq0dUJEYzqYDccsyH3YgCfX/Om
eOxZRGIEc0/BfbLY5Uhc4wY=
=ZQ/P
-----END PGP SIGNATURE-----

--==_Exmh_1305565337_2487P--


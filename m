Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab1IBKfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:35:24 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56167 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab1IBKfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:35:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v4 00/19] Staging: cx25821: Fix style issues
In-Reply-To: Your message of "Fri, 02 Sep 2011 11:55:28 +0800."
             <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314959695_2654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Sep 2011 06:34:55 -0400
Message-ID: <5753.1314959695@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4E60B154.00ED,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314959695_2654P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Sep 2011 11:55:28 +0800, "Leonid V. Fedorenchik" said:
> This patch series fixes some style issues in drivers/staging/cx25821

Happened to glance at a "Fix long lines" patch that actually improved
the code.  That's sufficiently rare I decided to look at the whole series,
which all looks good - the + lines in the patches generally are nicer
looking than the - lines. ;)

Feel free to stick this on the whole series:

Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1314959695_2654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOYLFPcC3lWbTT17ARAmeNAKCVvfp/4qj4bdnUqaUlU1OPUOs6xQCeN2pa
joiK+6Lu/r/blXHLRC6cxyA=
=19qc
-----END PGP SIGNATURE-----

--==_Exmh_1314959695_2654P--


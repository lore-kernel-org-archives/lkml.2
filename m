Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804Ab1FWUCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:02:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50429 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab1FWUCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:02:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Sergiu Iordache <sergiu@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samo Pogacnik <samo_pogacnik@t-2.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char drivers: Ram oops kernel configuration parameters
In-Reply-To: Your message of "Thu, 23 Jun 2011 11:36:00 PDT."
             <1308854160-16022-1-git-send-email-sergiu@chromium.org>
From: Valdis.Kletnieks@vt.edu
References: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1308859172_4530P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Jun 2011 15:59:32 -0400
Message-ID: <62229.1308859172@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4E039B29.009D,ss=1,fgs=0,
	ip=24.127.43.116,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1308859172_4530P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Jun 2011 11:36:00 PDT, Sergiu Iordache said:
> Ramoops currently has module parameters for setting the configuration
> variables (ram start, ram size and dump oopses). This makes it difficult to
> configure when the module is compiled as a builtin.

Can't you add 'ramoops.ram_start=128M ramoops.ram_size=64M' or similar
to your kernel cmdline?

--==_Exmh_1308859172_4530P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOA5skcC3lWbTT17ARAgVjAJ93b5K7g1r4KaDroQ/vGMcs/s0UvwCfRDg9
CcjijpYJDQ5h1W86wf0ogsc=
=Sev4
-----END PGP SIGNATURE-----

--==_Exmh_1308859172_4530P--


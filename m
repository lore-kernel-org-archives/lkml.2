Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1JQTug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:50:36 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41606 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1JQTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:50:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
In-Reply-To: Your message of "Mon, 17 Oct 2011 09:28:49 +0200."
             <1318836529.6594.20.camel@twins>
From: Valdis.Kletnieks@vt.edu
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name> <1318349729-3108-4-git-send-email-kirill@shutemov.name> <20111014154348.ae6267aa.akpm@linux-foundation.org> <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop> <20111017013921.GA30035@tango.0pointer.de>
            <1318836529.6594.20.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318880815_2955P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Oct 2011 15:46:55 -0400
Message-ID: <17708.1318880815@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E9C8634.009F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318880815_2955P
Content-Type: text/plain; charset=us-ascii

On Mon, 17 Oct 2011 09:28:49 +0200, Peter Zijlstra said:
> As to the proprietary plugins, let firefox spawn one per tab and simply
> SIGSTOP the thing when the tab becomes invisible or so, dunno.

Which really sucks if you're trying to listen to streaming audio from the tab
while trying to do other work.  Having to keep the tab visible is a pain.

(And yes, I know the *right* answer is to find a URI suitable to feed to amarok
or xine or something - but have you ever *looked* at the maze of indirections
and Javascript and Flash and who knows what other horrors some radio stations
go through to keep you from doing that? ;)


--==_Exmh_1318880815_2955P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOnIYvcC3lWbTT17ARAsb6AKCI70FYy6cHXN3V4v6+j1EcVAreigCfV1rd
2zc+WcYfE9fDEd6Tw1ALhh0=
=6vi1
-----END PGP SIGNATURE-----

--==_Exmh_1318880815_2955P--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab1JGQFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:05:25 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42847 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1JGQFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:05:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
In-Reply-To: Your message of "Fri, 07 Oct 2011 10:01:32 +0200."
             <alpine.LRH.2.00.1110070959470.14853@twin.jikos.cz>
From: Valdis.Kletnieks@vt.edu
References: <20111006190526.GA13883@redhat.com> <20111006194432.GA21642@kroah.com> <20111006195007.GA24900@redhat.com> <20111006195824.GA22033@kroah.com> <20111006200440.GB25681@redhat.com>
            <alpine.LRH.2.00.1110070959470.14853@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318003445_9306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Oct 2011 12:04:05 -0400
Message-ID: <14168.1318003445@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E8F22F9.0207,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318003445_9306P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Oct 2011 10:01:32 +0200, Jiri Kosina said:
> On Thu, 6 Oct 2011, Dave Jones wrote:

> > what stops an out of tree module from setting that flag ?
> 
> What stops virtualbox developers from renaming the module in every 
> release? That's the same story.
> 
> The only fool-proof way of doing is indeed is the GPG-signing thing.

It would also be a second in-tree user for the kernel MPI library code that
somebody posted recently... Just sayin' ;)

--==_Exmh_1318003445_9306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjyL1cC3lWbTT17ARAiKEAJwMYKxCzI2aVTkbv6h06FEN9HjmdQCgyhYE
uiOd2Ae3H78nt0Fyihmnb7Y=
=57Fs
-----END PGP SIGNATURE-----

--==_Exmh_1318003445_9306P--


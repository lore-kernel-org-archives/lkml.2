Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1GZT0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:26:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60467 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab1GZT0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:26:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Bob Zhang <zhanglinbao@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hayfeng Lee <omycle@gmail.com>, ak@linux.intel.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bob Zhang <2004.zhang@gmail.com>
Subject: Re: x86_64 virtual memory map
In-Reply-To: Your message of "Mon, 25 Jul 2011 18:13:16 +0800."
             <CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com> <m1r5n7ln0l.fsf@fess.ebiederm.org>
            <CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1311708366_2745P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Jul 2011 15:26:06 -0400
Message-ID: <46580.1311708366@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E2F14D0.003A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1311708366_2745P
Content-Type: text/plain; charset=us-ascii

On Mon, 25 Jul 2011 18:13:16 +0800, Bob Zhang said:

> 3,  if I installed 64TB physical memory (RAM) , but linux kernel only
> support 1TB address space , what should I do next ?

Prepare to explain to your boss why you blew the project budget by buying 63T
too much RAM without checking first if it was supported? :)


--==_Exmh_1311708366_2745P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOLxTOcC3lWbTT17ARAlEkAJ9SEz34MIr+IN5FzOn5ouRIvkM4gQCgrX5W
2MrsRwToDfSto3Iqo/u6xAw=
=rzSc
-----END PGP SIGNATURE-----

--==_Exmh_1311708366_2745P--


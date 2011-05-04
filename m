Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1EDUYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:24:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41196 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab1EDUYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:24:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: Your message of "Wed, 04 May 2011 15:04:39 CDT."
             <alpine.DEB.2.00.1105041454190.5495@router.home>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos> <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home> <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com> <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home> <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com> <alpine.DEB.2.00.1105041421280.5495@router.home> <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
            <alpine.DEB.2.00.1105041454190.5495@router.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304540499_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 May 2011 16:21:39 -0400
Message-ID: <19422.1304540499@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=35/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=suspect(0),
	refid=str=0001.0A020205.4DC1B555.00BB,ss=2,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304540499_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 15:04:39 CDT, Christoph Lameter said:
> On Wed, 4 May 2011, Linus Torvalds wrote:

> > But cmpxchg DOES NOT MAKE SENSE without atomicity guarantees.
> 
> This is not a real cmpxchg after all. Its not atomic in the sense of
> other functions. Its only "percpu atomic" if you want it that way. This is
> *not* a full cmpxchg_double().

Calling it a cmpxchg when it doesn't have the primary distinguishing property
of a hardware cmpxchg is just loading a bullet in the chamber and inviting
kernel hackers to point it at their feet...


--==_Exmh_1304540499_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwbVTcC3lWbTT17ARApiAAJ40IG5yrhZyPQ9C81jXlg4XY+d66ACeNtSU
s/Z1D+Pl/+k+sgXrrcWDKSs=
=G38D
-----END PGP SIGNATURE-----

--==_Exmh_1304540499_7352P--


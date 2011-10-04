Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab1JDXSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:18:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab1JDXSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:18:04 -0400
Date: Tue, 4 Oct 2011 19:17:30 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Valdis.Kletnieks@vt.edu, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111004231730.GB17089@redhat.com>
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu> <20111004223932.GA3460@localhost.pp.htv.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20111004223932.GA3460@localhost.pp.htv.fi>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi -

On Wed, Oct 05, 2011 at 01:39:32AM +0300, Adrian Bunk wrote:

> [...]  But the semantics of PGP key signing is that you certify that
> you verified that a photo ID of that person matches the name on the
> key.  [...]

But that's begging the question.  The semantics are what you want them
to be.  Some keysigning parties take this super seriously, and maybe
with strangers there's some room for this.  But in the end, when *I*
see a key with someone else's signature on it, there is no proof how
rigorously they investigated the person.  The "reliable identity" part
of the web of trust is only one hop deep.

- FChE

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFOi5QKVZbdDOm/ZT0RAtSyAJ4qQB+YSo8Chu/S98f2V5eMAo9J5wCfZqfQ
NRaSEYFkKoIZK9Zvv04k0RI=
=D3n1
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--

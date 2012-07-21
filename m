Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2GUUw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 16:52:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41399 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2GUUwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 16:52:25 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 0/3] efi_pstore: avoid losing critical message
In-Reply-To: Your message of "Thu, 19 Jul 2012 21:11:44 -0000."
             <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FAA@USINDEM103.corp.hds.com>
From: valdis.kletnieks@vt.edu
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FAA@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1342903942_3823P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Jul 2012 16:52:22 -0400
Message-ID: <54552.1342903942@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.216.45 mail-qa0-f45.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.500B1688.004F,ss=1,re=0.000,fgs=0,
	ip=71.62.120.57,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1342903942_3823P
Content-Type: text/plain; charset=us-ascii

On Thu, 19 Jul 2012 21:11:44 -0000, Seiji Aguchi said:

> [Solution]
>    To avoid losing a critical message, this patchset is based on a following concept.
>      - A basic policy is _not_ to overwrite existing entries.
>
>      - However, if kernel panics while a system is rebooting, a critical message
>        can't be saved by the policy above.
>        (In this case, panic message is critical.)

OK, system boots in "overwrite mode", and when done booting, we go into
"non-overwrite mode".  Makes sense to me.  Only part I'm missing is how/when/why
we leave overwrite mode - what makes the change, and how?

(If I missed an ioctl or /sys entry or something that userspace toggles to say "I'll
take care of it from here", please point me at it and I'll go re-read after I find
some more caffeine ;)

--==_Exmh_1342903942_3823P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUAsWhQdmEQWDXROgAQIy5w/+NYRpwh9+gunD6rjAfc6NsG3o/bF/ns6B
/9qhNtD+Wc0K6k8E3e3S3qw7e7DBb/VWJ6SnNhIh2P4Gk5Lh4O/UHEa2P/0G+m6w
3C7dCs5RnKHCh+gbPVjq1RsZ/YR6M7tchK5C2G+i/o/tFk/YpFScXFpZN/vs5cAn
GI9SCyW09ZWKNrJ/UfWDQO6FyQKW5Cb6XaLXLqRI/M7lxN2cb1lmTtt9+3+89lmA
GVbQsfeAs8eWHfJecz/wYw+x1cOUhg3IDLsAWgfHYpizaqvxZ48yYUSTm31fwd9f
AZuCXOdRQD2Xo0uwxlMljioMCrJWUKiN6ZsleCP1J8MgRtr1KsIGAtHWI8EPzIvL
fe//4ysNP99UoHVWR55pULOGmcfRp34SXr0Q+GelA82vt3wSSJ0l0NZu5+BtMiO1
DgXKWjguth6PIOYj1k0fD838o24z7qDfzm0/FCVaGvFj/IwjkpCDq90z2eDXsMYV
bCmhqDKFaNPdnhEzKh/6/e/LuVd9jxslMcf09evTnKbbG8KcP1+6IcoRkenQYo36
b7DwMVhwBRdxWpv56BDk/FPMQgJByCx4yM3ascaSoqU9cQF6K8ZIS/LpH88YWqKG
6aQPRRfA44A+w922xq5NZP5Wr/xzgxRxV7fFpoii6aYbhjSaatl6v5vW/fyJoOM4
BQ1qTnayVJE=
=j96g
-----END PGP SIGNATURE-----

--==_Exmh_1342903942_3823P--


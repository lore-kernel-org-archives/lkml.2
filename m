Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0KLHqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 02:46:14 -0500
Received: from relay.felk.cvut.cz ([147.32.80.7]:12530 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab0KLHqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:46:13 -0500
X-Greylist: delayed 2042 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 02:46:12 EST
Date: Fri, 12 Nov 2010 08:11:58 +0100
From: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
To: linux-kernel@vger.kernel.org
Subject: Re: Sync semantics.
Message-ID: <20101112071158.GG16758@myhost.felk.cvut.cz>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20101111125219.GA945@bitwizard.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j2AXaZ4YhVcLc+PQ"
Content-Disposition: inline
In-Reply-To: <20101111125219.GA945@bitwizard.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-FELK-MailScanner-Information: 
X-MailScanner-ID: oAC7BwJE091951
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.9,
	required 6, autolearn=not spam, BAYES_00 -1.90)
X-FELK-MailScanner-From: michal.svoboda@agents.felk.cvut.cz
X-FELK-MailScanner-To: linux-kernel@vger.kernel.org
X-FELK-MailScanner-Watermark: 1290150720.00352@X4dJS8m/Am9IdKM72+mHng
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j2AXaZ4YhVcLc+PQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rogier Wolff wrote:
> What should I expect from a "sync" system call?
> # time sync
> 0.000u 0.220s 2:22:23.96 0.0%   0+0k 0+0io 2pf+0w
> Two hours 22 minutes.=20

I would also be interested to hear the answer for this question. Sync
and ongoing i/o simply don't seem to play well together, and you don't
even need anything as heavy as mentioned above.


Michal Svoboda

--j2AXaZ4YhVcLc+PQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAkzc6L4ACgkQg/fU9pp1uX4g+QCgsh4zJNbD+it8ia6ZLTIwUffd
cLEAmwVzvn+yyVa+0x2I9uCIu24afxJY
=poJE
-----END PGP SIGNATURE-----

--j2AXaZ4YhVcLc+PQ--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab1IGSgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:36:38 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:34382 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1IGSgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:36:36 -0400
X-Greylist: delayed 5403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 14:36:36 EDT
Date: Wed, 7 Sep 2011 10:50:37 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jean Schurger <jean@schurger.org>,
        Jan =?iso-8859-1?Q?L=FCbbe?= <jluebbe@debian.org>,
        Nacho Barrientos Arias <nacho@debian.org>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
	(Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20110907085037.GX10237@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Tejun Heo <tj@kernel.org>,
	Jameson Graef Rollins <jrollins@finestructure.net>,
	Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
	Martin Pitt <martin.pitt@ubuntu.com>,
	Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
	Jean Schurger <jean@schurger.org>,
	Jan =?iso-8859-1?Q?L=FCbbe?= <jluebbe@debian.org>,
	Nacho Barrientos Arias <nacho@debian.org>
References: <20110406121920.GC4142@mtj.dyndns.org> <20110903221456.GA2877@elie> <20110904024244.GB3083@htj.dyndns.org> <87y5y37o7h.fsf@servo.factory.finestructure.net> <20110906174524.GN18425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YY58jJdr0zvR1wPt"
Content-Disposition: inline
In-Reply-To: <20110906174524.GN18425@mtj.dyndns.org>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YY58jJdr0zvR1wPt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tejun,

> Also, can you please explain the steps needed to trigger this problem?
I'm not the one that supplied the backtraces, but I'm having the same
problem. I did a fairly extensive writeup on the Debian bug report,
perhaps this could (help to) answer your question:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=628600#23

I'll leave the other questions to Jameson for now.

Gr.

Matthijs

--YY58jJdr0zvR1wPt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk5nMF0ACgkQz0nQ5oovr7xxCgCg0iJBeWjYHtrjuDXkSvzTCwt7
08kAoJ3vLiFJFV0c9mixBxfJrPKmKVis
=GYU6
-----END PGP SIGNATURE-----

--YY58jJdr0zvR1wPt--

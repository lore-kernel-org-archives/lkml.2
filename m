Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1LSLMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:12:23 -0500
Received: from drsnuggles.stderr.nl ([94.142.244.14]:59299 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab1LSLMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:12:21 -0500
Date: Mon, 19 Dec 2011 12:12:08 +0100
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
	(Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20111219111208.GP15486@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Tejun Heo <tj@kernel.org>, Gaudenz Steinlin <gaudenz@debian.org>,
	linux-kernel@vger.kernel.org,
	Jameson Graef Rollins <jrollins@finestructure.net>,
	Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
	Martin Pitt <martin.pitt@ubuntu.com>
References: <20110906174524.GN18425@mtj.dyndns.org> <20110907085037.GX10237@login.drsnuggles.stderr.nl> <20110911040826.GP29319@htj.dyndns.org> <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me> <20111026182650.GL14392@login.drsnuggles.stderr.nl> <20111026222510.GK24261@google.com> <20111028134743.GU14392@login.drsnuggles.stderr.nl> <20111030203503.GB7696@google.com> <20111031092812.GD14392@login.drsnuggles.stderr.nl> <20111031152612.GG7696@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t5nrWwxhu9iPV6+h"
Content-Disposition: inline
In-Reply-To: <20111031152612.GG7696@google.com>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t5nrWwxhu9iPV6+h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tehun,

I've been running the tj/misc.git kernel (a3b96625209aae) for six weeks
now, the suspend problems have not occured once since then. I suspect
it's safe to say that the problems are fixed in that kernel.

Are these fixes pushed to the main kernel tree yet?

Gr.

Matthijs

--t5nrWwxhu9iPV6+h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk7vHAgACgkQz0nQ5oovr7zoMgCfThB6ya/J29EDBD2FYRQMizSP
YEoAn2Jo3vzKCVKAVw9ErERmEcd76Znn
=Ul/+
-----END PGP SIGNATURE-----

--t5nrWwxhu9iPV6+h--

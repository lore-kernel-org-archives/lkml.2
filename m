Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab0KOHmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:42:50 -0500
Received: from relay.felk.cvut.cz ([147.32.80.7]:53452 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab0KOHmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:42:49 -0500
Date: Mon, 15 Nov 2010 08:42:41 +0100
From: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
To: linux-kernel@vger.kernel.org
Subject: Re: Sync semantics.
Message-ID: <20101115074241.GH16758@myhost.felk.cvut.cz>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20101111125219.GA945@bitwizard.nl>
 <20101115023932.GD22876@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FUaywKC54iCcLzqT"
Content-Disposition: inline
In-Reply-To: <20101115023932.GD22876@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-FELK-MailScanner-Information: 
X-MailScanner-ID: oAF7gfoK014071
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.9,
	required 6, autolearn=not spam, BAYES_00 -1.90)
X-FELK-MailScanner-From: michal.svoboda@agents.felk.cvut.cz
X-FELK-MailScanner-To: linux-kernel@vger.kernel.org
X-FELK-MailScanner-Watermark: 1290411763.51523@/XAEegHH5yBlANnleaI/Jg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FUaywKC54iCcLzqT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Dave Chinner wrote:
> Depending on the kernel, sync will keep writing if you keep
> dirtying. This should be mostly fixed in 2.6.36....

Is that a "we hope that it is so but we are not sure" kind of "mostly",
or a "there are known cases when this is not true" one?

Michal Svoboda

--FUaywKC54iCcLzqT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAkzg5HEACgkQg/fU9pp1uX5irACggvOc6bw8jTDSZc1AZMt0uw9A
LgsAnAqy8ubqFo1BI8gbylTfnIMUPY59
=nNx0
-----END PGP SIGNATURE-----

--FUaywKC54iCcLzqT--

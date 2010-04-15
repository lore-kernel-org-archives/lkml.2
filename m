Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab0DOGgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:36:48 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:53248 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0DOGgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:36:47 -0400
Date: Thu, 15 Apr 2010 08:36:26 +0200
From: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default
 y
Message-ID: <20100415063626.GG21894@myhost.felk.cvut.cz>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20100413025228.GC10860@localhost.localdomain>
 <m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GdbWtwDHkcXqP16f"
Content-Disposition: inline
In-Reply-To: <m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-FELK-MailScanner-Information: 
X-MailScanner-ID: o3F6aQf0077535
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.9,
	required 5, autolearn=not spam, BAYES_00 -1.90)
X-FELK-MailScanner-From: michal.svoboda@agents.felk.cvut.cz
X-FELK-MailScanner-To: linux-kernel@vger.kernel.org
X-FELK-MailScanner-Watermark: 1271918188.85544@9qQc7cEHXa6MsTSi5IiDdA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GdbWtwDHkcXqP16f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Xiaotian Feng wrote:
> Have you ever successfully attack by this way? If CONFIG_STRICT_DEVMEM
> is not set, the /dev/mem access is filtered in pat code.

If that option doesn't add any protection, what's it good for?

--GdbWtwDHkcXqP16f
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvGs+oACgkQg/fU9pp1uX5uNQCeOUbNUldpqbmMtnW94XXLgGhD
XREAn0/FfLnb9LZaFfDaJDQjeIT2qIoN
=cxKh
-----END PGP SIGNATURE-----

--GdbWtwDHkcXqP16f--

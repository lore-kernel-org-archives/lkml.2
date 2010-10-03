Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0JCRKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 13:10:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33016 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab0JCRKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 13:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=naP8DXaPRYosVkkk3c3KkI0/9L0WtkdYwm1qQyiEgkPABsrOgvX4/Tx5zhffLFgcEM
         I47Xkb8PWMm2KiOBTZF1RulyHrhdsrPgobFEL1XB3skkcp639kH47d3q56bkqvnHhUgS
         fGEiCSn6fmFFwS619rNRB2T23slsNu6wp5uT0=
Date: Sun, 3 Oct 2010 13:10:15 -0400
From: tmhikaru@gmail.com
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later
Message-ID: <20101003170912.GA18972@roll>
References: <20101001035321.GA2360@roll> <20101001094814.GA5029@roll> <20101003030254.GA4901@roll> <20101003122143.69cd3b9a@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <20101003122143.69cd3b9a@schatten.dmk.lab>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 03, 2010 at 12:21:43PM +0200, Florian Mickler wrote:
> Don't apologize, it's heroic. Do you still see the performance
> regression you reported in your original bug report? I don't exactly
> know if you are at the moment just talking about the bisected commit or
> if the performance regression you saw earlier was just some cosmic ray
> kind of thing...
>=20
> If the load-average thing was just a red herring, it would probably
>  still be worthwile to bisect the performance regression.

No, I do not see the performance regression anymore, which is why I did all
that extra testing with the timed compiles - it proves that somewhere along
the line I made a mistake, and tricked myself into believing the load
average glitch *also* was causing performance issues. I was wrong.

Given I only started digging into the problem as far as I did because I
thought it was slowing things down, it's annoying. However, at least I did
find a real problem.

Tim McGrath
--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKi495EncCrqzVruAQLt+Af/aUe4/z7UvWVGvOXcR9o37QyjfNMb6iXf
zJrIp7+xY/dJsOS0SvR4r+/c310boekJtnRX66NwMH6hKAeGa/D2dqoLGoptiYeR
oNxw6G+31IiGQZVeieEyCHz/1pO7rCYTC6x5kfJI2hFUjBu4FXVxUZzHBDU+9uGM
gI5CX08X4uTSPwJzfmrFhNzL7m7ZPYeXwNRLu8HIRukGVG7ki06SL38U3nzgqP7t
oP6tnBP9l0u8/aPo81niTV9OoNeWol6CUb1fXZVfvSiEcKl8DqEmB8XT4n5w7YIa
2YKV7lK6rgD0TgFb0TrjmsLiWKjEJY9PZegmJJApsUHU8oUdl93Mpw==
=zCQB
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0IPUIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:08:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43493 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0IPUID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Obpbn8awgyLM82Jdzvrab+yxPpWngwbuE6fIgs+iudak+alhJzkHnyBorSuLPQpWDj
         jQFNynbrDG2Y4KROrPtjtF/k4HI04K7cq8RPUn0fE7Djn9sDU9P7PRQVodRo5gMNYhIo
         t+uWEJGvYGoNfiGqHF2xBtw2X2vP5bU//76Ac=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Thu, 16 Sep 2010 23:06:46 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-git2-anarsoul; KDE/4.5.1; i686; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <201009162142.10629.anarsoul@gmail.com> <alpine.LFD.2.00.1009162049450.2416@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009162049450.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12866861.2dd8kzp0Kl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009162306.59508.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12866861.2dd8kzp0Kl
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
16 of September 2010 21:50:50 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Thomas Gleixne=
r =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> Ok. The problematic part of HPET was not the clocksource, it was the
> clock event device which failed to deliver interrupts occasionally. It
> was worth a try at least.

Hm, it seems that jerky glxgears is not related to jerky keyboard events.=20
Keyboard is jerky only in konsole (kde terminal emulator), it seems somethi=
ng=20
happened it seems that font rendering performance is much worse in latest=20
xf86-video-intel than in xf86-video-intel-2.12.0.

Regards
Vasily

--nextPart12866861.2dd8kzp0Kl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkySeOMACgkQRM6pQpltKE5vxwCgzEvvjKU7v16davAK6YkaG/jf
WPUAnj7hAYgmZdUQNQxHraKww8RY5uTT
=BHnw
-----END PGP SIGNATURE-----

--nextPart12866861.2dd8kzp0Kl--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab0I3BdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:33:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58096 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0I3BdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wW2tbyi7PXLNS3KjV5uoh3ORPCi+Mhhu9YWr5L0MIOib5kW/Q0gM8LMVq0KzZoqoJ/
         ZC6ovvbQWJS7OTW3kGHf9GiP6spK6KA59GmezCO62uITDF1GA+2JSA6TRQD5EvykTn9L
         5rQtkWUPf156uZzGXNEf5yVVTQhpdUa+OIg4M=
Date: Wed, 29 Sep 2010 21:33:05 -0400
From: tmhikaru@gmail.com
To: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.35.6
Message-ID: <20100930013305.GA23569@roll>
References: <20100927003608.GA20395@kroah.com> <20100927163208.GA4892@roll> <20100927215135.3d11d587@schatten.dmk.lab> <20100927233956.GA15705@roll> <20100928083505.0a808ffd@schatten.dmk.lab> <20100928190358.GA24303@roll> <20100929092924.2090f19e@schatten.dmk.lab> <20100929110247.GA2032@roll> <20100929135248.09cd7a84@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20100929135248.09cd7a84@schatten.dmk.lab>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2010 at 01:52:48PM +0200, Florian Mickler wrote:
> In all cases, you can simply do the bisection based on the 'load
> average' criteria and then later check if the changeset that you've
> found that way also influences the kernel compile times.=20
Works for me.

> Out of curiosity, what region are you circling in?
git log says I'm at
commit e7858f52a5cb868289a72264534a1f05f3340c6c
Merge: 27a9da6 bbf1bb3
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat May 8 18:11:19 2010 +0200

    Merge branch 'cpu_stop' of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc into sched/core

but I don't know if this is the right command. I'm almost entirely a novice
at git... Anyway, I haven't tested if this particular commit works yet, I'll
be rebooting after I send this email.

> One could also just use awk for this. ( awk '{print $1}' /proc/loadavg)
Thanks for explaining what it's doing. I assume if I wanted to use the third
argument I'd use
	awk '{print $3}' /proc/loadavg
correct? I think I'll be using that since it'll give me a better clue if
loads are consistently high over a long period, as well as make the loadavg
graph less prone to jitter.

Thank you,
Tim McGrath

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKPo0ZEncCrqzVruAQJONAf9HvuwWNIdEi6o79xwlTwUIRzriu7URt/B
Ers2uDxBDYbF8brc4J5mj01jTAHS/eW7mQ2IuVKywVI2i71mhnorbdDHWOSrqlBI
ZcYyPSn+8Fhm4KtlBJDycp+TrNlzIM3YFoM3yZwJTkmf407hI8wOTVrjaAsPhH1Z
wShhWEusz/C8BNLXLGzDy80h+rWv8EOWCwaIz1LbycvTxIJ9FEPTjharLL5kRxX0
IaTJXb9fwMmslBBxrFkbEWNmuvvau46YZFdKW6qVaUtxyfgIFqmdJELNhgARYI+A
JWR+TmJFX6g04Trssai0aXPxXsMEfqazCu2/gfBLJ17Pdw6OlZth+g==
=e2v4
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--

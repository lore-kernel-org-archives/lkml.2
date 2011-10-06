Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab1JFXaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:30:04 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:56314 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150Ab1JFXaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:30:01 -0400
Date: Fri, 7 Oct 2011 10:29:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: Including C6X in linux-next
Message-Id: <20111007102953.7b533ec58dd613b9fd78a198@canb.auug.org.au>
In-Reply-To: <1317917085.2703.16.camel@deneb.redhat.com>
References: <1317917085.2703.16.camel@deneb.redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Oct_2011_10_29_53_+1100_iPLTM927E+TXjDJu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Oct_2011_10_29_53_+1100_iPLTM927E+TXjDJu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, 06 Oct 2011 12:04:44 -0400 Mark Salter <msalter@redhat.com> wrote:
>
> All of the patches in the latest C6X patch set have gotten Acked-bys, so
> I guess its time to include it in the linux-next tree. The patches are
> available on the "for-linux-next" branch at:
>=20
>    http://linux-c6x.org/git/projects/linux-c6x-upstreaming.git

I had a look at this and unfortunately you have based it on linux-next.
I cannot use it like that.  You need to rebase this onto Linus' tree,
sorry.  (Also, I used the git://... version of the URL as that is more
efficient than http://.. for updting git trees).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Oct_2011_10_29_53_+1100_iPLTM927E+TXjDJu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjjnxAAoJEECxmPOUX5FECPoQAKnWCqFy0P8D6HTNdcUTgpR+
9g911QvT4W76SiBOldhPMJUwQDqvZ14rhOZU7wJ7AgCOH6wqvfVmbRlvlbxtBaZy
tGbeka4KKDra8rshZ0zZHroNiH1gjdJvD2LujfgYn3nK+KNC5NYteC3mzSPWK7Sb
pZooGcCl8GTLpBPZY0LwQIFimhBuxcx3D3QrJnf8+OLLDp0lto1Ig/+wxgC0+b07
DHNDOj9mAaX/SyL/7wkBSENxad31MzN1bhBwLB5hbU3sXZp7pb3IC3y1QsGNIGS4
9NfSqUdPyyc4WDXqCcnXt6EyO9Mb3wo+4pXaZhn1p9FJpBxvEt4oJcwQLh/dFV96
npxTzONqUbvCfHGUf3JsxJpcgVDUZMbZ3fRG/PSfzZoG9S0XBTBAn3p89jDnJH7Y
StPife+6ZddeCEpAujSV8OxYRVzIYQ2xXQOqp1cHrn8Re2NCHyZpWhiRQN0G5rFf
qfczVo9BO2reT7H8z9aSOn7NauocTXq72O7NDUu9Od4AbWQN1md+c6yVjA9TuWCa
YhRh9vKIcXLj8Awyx0Y3EP3J20z5InuaqOZQz3krgYBTMyh5/MP55l1WTMTcvIUj
Yt8L7TssC5ENvhDP4RfOdO5f6ZLp9BcE1h762HXT6trl7oD09ulIPsxHo8bZjNc0
RQqN8fC6L2KhWq1xHOui
=vN9x
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Oct_2011_10_29_53_+1100_iPLTM927E+TXjDJu--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1KWUsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:48:18 -0500
Received: from home.keithp.com ([63.227.221.253]:35500 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab1KWUsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:48:16 -0500
From: Keith Packard <keithp@keithp.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] iommu: export no_iommu and dmar_disabled symbols
In-Reply-To: <1322080560.15493.206.camel@shinybook.infradead.org>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com> <1322073734-26840-1-git-send-email-eugeni.dodonov@intel.com> <1322080560.15493.206.camel@shinybook.infradead.org>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 23 Nov 2011 12:48:19 -0800
Message-ID: <86aa7mefak.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 20:36:00 +0000, David Woodhouse <dwmw2@infradead.org> w=
rote:

> This is horrid. In the general case, drivers have no business knowing
> this. We need to properly identify what is wrong with this hardware, and
> put in a quirk for it =E2=80=94 perhaps refusing to enable the IOMMU at a=
ll on
> the broken chipsets.

That'd be fine with me, right now we're disabling RC6 and semaphores --
semaphores aren't all that important, although they do improve
performance a bit. RC6 is important, saving a huge amount of power.

I'd also be OK with requiring special options to enable DMAR and having
that also disable RC6/semaphores, if you'd rather expose that. In either
case, we need something that works and avoids hanging machines.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTs1cEzYtFsjWk68qAQixXhAA1PVbZutToPD6uqqdXsDzmRi+EDsg02ek
d3o+yHG+VZ/Wxx66h6fNrFE8LPtj8pQZu0GB3yOGer+PTGOsFk9gPlMOvhjLEjYs
o5Lk09mDEzQM4cm4VKBlcu5mAJZGi1mrFOoSfmmoXPo/QtKbiJdq/9x4+4jKa48t
Xi+luNlUotseONp549o662NNm/PEQaWcCHoetHDlhSagYg0I0fKsO6rja6+tMwnr
QWlT0KBCF+Q8JxemnJqaTg+ah4vy1gEG9A6blUg2VlOEkF5MnwYAOtsZ4uhvZlyO
5nCOFJfYFY0eGgwbSRzRCc40RHdCdQGiuoPOb0V1i6gdt5DGe45M82+Dk+RVbWPk
piTJW6ghM2mKF4f5vKnVsIOH+pbI8qZyt5bD8E9sAt0/caUyKOEuA0RX/tMSbKla
DSkcp9HYtgA9mDoEEX80ZU3Q4SXv2qoQIJZX5hYAOjvR9pS7OyL5Ems8D3FfG7FR
fec+HC6oyjOEFblQYrlhT/WWk7ALXGNezjsv2YIrNjH0umhZtQX6e5ObxwK7Psvv
8yeyNAjG9vwNhWEIgl5BR5l5C7ohLvc07Ps/NNiHZRviBgXA5q3EGq5X8tSGmVXk
PETFdV5cCAzq/Cx4vL7Diid9OG8bX12SiiRymM4b5eGCIaRhGxx2F+VeElZyxH9E
0SX2Sw43TQA=
=3bpj
-----END PGP SIGNATURE-----
--=-=-=--

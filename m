Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1BJEqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:46:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40895 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab1BJEqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:46:51 -0500
Date: Thu, 10 Feb 2011 15:46:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: build failure after merge of the xen-two tree
Message-Id: <20110210154648.8b3b994e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Feb_2011_15_46_48_+1100_xqNk3X5Wvb3N5A70"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Feb_2011_15_46_48_+1100_xqNk3X5Wvb3N5A70
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the xen-two tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpio/langwell_gpio.c: In function 'lnw_irq_handler':
drivers/gpio/langwell_gpio.c:210: error: 'struct irq_desc' has no member na=
med 'chip'
drivers/gpio/langwell_gpio.c:211: error: 'struct irq_desc' has no member na=
med 'chip'

Caused by commit e22ff7614860bc282ba1eb25440d8fc56975e357 ("xen:
Interrupt cleanups").

I have used the version of the xen-two tree from next-20110209 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Feb_2011_15_46_48_+1100_xqNk3X5Wvb3N5A70
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNU224AAoJEDMEi1NhKgbsZ7IH/2EJbZsENGxTGA55TX8/5FUZ
AJSlrbsp8qZtFNeCXUD6ImZKLQLoWihSrSS2tXYmH3m3T4qjjoZLfXYLpSDduemz
ifjk/OZnZJ6ZHCH1U2hSrqzPSvSyKM8+wiBfL42NrIAywt1DSMLLF0CK1kyQVNcU
DF71w+nVvoscD4GcCLT+zjpVn6SwFaWyxUhfHiF7FU1wsM37ryA6ndFC7vurq4wY
R1tTz7P5JxQSH06PuVE0XwqPV6iWdUx7DN8xLPFpDstLoqvJAbYXTOPUNZGojiUu
WA57XlyYM36zCeAw096pgKJsI2/gb2hOZ00awvcu57XEGPGJiJbPQLHZjNpjjY8=
=+SCN
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Feb_2011_15_46_48_+1100_xqNk3X5Wvb3N5A70--

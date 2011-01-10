Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1AJWUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:20:25 -0500
Received: from nm22.bullet.mail.sp2.yahoo.com ([98.139.91.92]:30909 "HELO
	nm22.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754609Ab1AJWUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:20:23 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 406399.22767.bm@omp1009.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=pyBuM/Un1dW4ccX325OYYL3R3l50LdXMqy23VPRzVRF5y6u68VIpKroOw3EFhOCjonptejSSqIzR87QMTgra7WRuUAUsrVtG69xZRnDiRGj90Te/a8P/P6pem9X13KtxpHltpGKK7SiCsuXufpIT1+lF57iA+FAGCR3B8wfJdq8=;
Message-ID: <909411.87280.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: psNRgkEVM1kalkGVhaMyVwT8YKiXjtdSF_Tj8xV3tZes_no
 EjTLkVK6.OgRO3sJ3vlZi4vflg5gGylJoiRo_yDgntPHqOIUIdpj7zb6MoEN
 D8.hXYDpkft4snvTvhL9Wi813PF1yAjoRTC3O3TZvgAr76VSbnOffzxzgicA
 _J5NI8lKPD8kYoiNJiJCc2TlOi9bV.tFlfY5a8fJF5jJdo5meP.413jN89Gd
 Q7sHTBUxz0jjbd7rhYvaDyQbva0ptfpre4uchSHT29JvRXRWarctio_mbI7M
 _G3OmK6Zglrpnh82Om7zWecib31XMG06BchBItZ79b3MLKgLq2C4A5VXFan8
 DnISatuBdYdZ2zpyBsQnIHRePDAnigcYmUyHFtuUHpy9dWzif9CCLqJ_fSxy
 9RUE_zzNvEIastPX0vu1XkV65Sw--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 10 Jan 2011 14:20:21 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] mtd: sst25l: fix reads with broken spi-masters
To: linux-kernel@vger.kernel.org,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>
In-Reply-To: <0D753D10438DA54287A00B027084269764CDF4146A@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 1/10/11, H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> From: H Hartley Sweeten <hartleys@visionengravers.com>
> Subject: [PATCH] mtd: sst25l: fix reads with broken spi-masters

NAK.  I'm surprised you even thought to submit
such a clearly-wrong patch.

The bug is in the SPI master driver, and thus
so should the fix be.  Or make your system use
the GPIO based SPI master driver.





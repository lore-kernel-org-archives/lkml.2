Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0H3XnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 19:43:07 -0400
Received: from n4-vm0.bullet.mail.gq1.yahoo.com ([67.195.9.7]:27966 "HELO
	n4-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753999Ab0H3XnG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 19:43:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 1616.21495.bm@omp128.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=DTzZuwnLqfbgPdkOdzyPSclLr79k/LoXmL5vJ90UxEoe0xqbf38lRSjNOU8l7LMeOs7wMR/QHXJTEZPbFDnSlOkEBez6hfPvcsnRCReJkXazxA8f3EJjg5ljqzvs7LPxsSVMv0zEoADRkJ0Psh+daXbOWatqENSiIEa5vQE7q40=;
Message-ID: <887649.75421.qm@web180316.mail.gq1.yahoo.com>
X-YMail-OSG: CBPSNygVM1kQGMdZ0kk_ya6zlLKTKVBys9pdlIQ7buoGbX8
 LQptaOTTAK0K5htYPb64c1XZfe711U3mCpFOa5bkgz2f8w1foFT_PeV80xm4
 Rc9e_RXhEuYHcXFRgf.yDDLX8sIqxxQQNDNN2fAUXc2MLQzoRLU5qR5DlJu8
 FYhaa34MSLP3i0EFLDdVBofYRfDDmevqhIGRnz6nUCQcRgEnWblB.ug6X4Mu
 b7vmmr09rZXrb7kSOjFD9L4M0vPdhD5CdlZTORJvO_0yf8J52pj3JHagC0uo
 otHwa26E7C.25Kgb94HlzD5YvGyAF.YgnT3cxGHuW5DPrhrlI9mfvjw--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 30 Aug 2010 16:43:04 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] GPIO: add support for 74HC164 serial-in/parallel-out 8-bit shift register
To: Willy Tarreau <w@1wt.eu>, Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>,
        dbrownell@users.sourceforge.net
In-Reply-To: <201008291737.32433.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic to all
> 74HC164 chips

Not just HC-series logic, also HCT, AC, etc (as
I noted previously).

I'm glad you took NXP (one of the N vendors)
out of the name, but I think you should also
 take the logic series out; "74x164 might be sufficiently generic.
           
> pdata->gpio_pin_clk, err);

I'm a bit puzzled why you don't just hook the
chip up using standard SPI signals... ISTR they
matched up directly to what the chip needs, so
no GPIOs were needed for interface glue.
>


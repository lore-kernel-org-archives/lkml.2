Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1DHROL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:14:11 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49537 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab1DHROK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m/uJbcNO0bsL3Djskc0Cci9e+T2TFzuyYRrWt6/J0Ob1WhszCHwUwfPAcBMY2ly5LK
         S0xDCDAhpmqgM12fNKWgezxdWpg8/DKlgm/Sro3KQDY5wp9JTDFGEFPh1hErwybhN4C1
         WZllVGdzIJO93bnDG+LzEmC07hlKa7JTFfZIA=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=DiGX=yg9HAxYHwKdOvedJdYC_sw@mail.gmail.com>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<BANLkTin1yyow595tcYveB5fh8q3x+U_GOw@mail.gmail.com>
	<BANLkTi=DiGX=yg9HAxYHwKdOvedJdYC_sw@mail.gmail.com>
Date: Fri, 8 Apr 2011 19:14:09 +0200
Message-ID: <BANLkTinCFnFELn_BPFWE+WCHtZB7d0o1gg@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Rafał Miłecki <zajec5@gmail.com>:
> 2011/4/8 Rafał Miłecki <zajec5@gmail.com>:
>> Could you say something more about *class*, please? For my BCM43224 it
>> seems to be 0x0. WIll check BCM4313 in a moment.
>
> Same for BCM4313.
>
> BCM43224:
> axi: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
> axi: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
> axi: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
>
> BCM4313
> axi: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
> axi: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
> axi: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)

This is last one, really ;)

This is MMIO dump (from wl):
R 4 92.541328 1 0xfaafc000 0x4bf80001 0x0 0
R 4 92.541351 1 0xfaafc014 0x4bf81201 0x0 0
R 4 92.541373 1 0xfaafc028 0x4bf82001 0x0 0

So there is not any mistake in my reading code. This the youngest 0x1
is SCAN_ER_VALID.

-- 
Rafał

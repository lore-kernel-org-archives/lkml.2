Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab1DLVAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:00:43 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:21962 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab1DLVAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:00:42 -0400
X-MDAV-Processed: mail.academy.zt.ua, Wed, 13 Apr 2011 00:00:40 +0300
X-Spam-Processed: mail.academy.zt.ua, Wed, 13 Apr 2011 00:00:39 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: balbi@ti.com, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	 <20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	 <1302634039.14216.10.camel@dev.znau.edu.ua>
	 <BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
	 <1302635550.14216.21.camel@dev.znau.edu.ua>
	 <BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
	 <4DA4AC4B.90409@hauke-m.de>
	 <BANLkTiknRYWaDM1ThAxgXcdGqK8jeFaBPA@mail.gmail.com>
	 <BANLkTikqKtJuDS17mfFvxzMoXuBtJvCgTA@mail.gmail.com>
	 <1302640546.14216.65.camel@dev.znau.edu.ua>
	 <BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 12 Apr 2011 23:57:34 +0300
Message-Id: <1302641854.14216.77.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2011/4/12 George Kashperko <george@znau.edu.ua>:
> >> 2011/4/12 Rafał Miłecki <zajec5@gmail.com>:
> >> That way I see really low (or not at all) relation between out
> >> (not)Broadcom bus and present AMBA bus.
> >>
> > Agree.
> 
> Ehh, sounds like one more renaming to functions, defines, prefixes.
> 
> Let's wait for Arend comments, he was the one voting for not-bcm-specific name.
> 
Sounds like good plan :)

Btw, while waiting.... Digging the web clearing different things around
ssb/axi found few broadcom ssb docs some of you maybe find interesting
to look through.
http://read.pudn.com/downloads127/doc/fileformat/537112/mips/bcm5836/5836-5836P-PG01-RDS.pdf
http://www.broadcom.com/collateral/pg/440X-PG02-R.pdf

Also, one more question to Arend:
could you please ask if there are any plans on lifting UNPUBLISHED
PROPRIETARY for GMAC core driver sources (etcgmac.c, have this core at
bcm4716-based ASUS N16, might used at other bcm471X socs as well) or
possibly Broadcom could publish some doc for the chip?

Have nice day,
George




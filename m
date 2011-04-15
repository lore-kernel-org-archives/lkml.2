Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1DOT4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:56:46 -0400
Received: from foo.stuge.se ([212.181.44.140]:45223 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751246Ab1DOT4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:56:45 -0400
Message-ID: <20110415195642.22440.qmail@stuge.se>
Date: Fri, 15 Apr 2011 21:56:42 +0200
From: Peter Stuge <peter@stuge.se>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Arend van Spriel <arend@broadcom.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-arm-kernel@lists.infradead.org, b43-dev@lists.infradead.org
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
Mail-Followup-To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	George Kashperko <george@znau.edu.ua>,
	Arnd Bergmann <arnd@arndb.de>, Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
	Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-arm-kernel@lists.infradead.org, b43-dev@lists.infradead.org
References: <1302781431.21145.6.camel@dev.znau.edu.ua> <BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com> <4DA6E9BD.3090404@hauke-m.de> <BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com> <1302786900.21965.52.camel@dev.znau.edu.ua> <BANLkTimM8=-pX+Ea8Eyp4XyvP1APbUof9w@mail.gmail.com> <1302892585.30441.12.camel@dev.znau.edu.ua> <BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com> <1302896541.30441.33.camel@dev.znau.edu.ua> <BANLkTinPVaYC14Y=m5iu7GYodkRb6uTuPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinPVaYC14Y=m5iu7GYodkRb6uTuPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> > On other hand just broadcom-specific bus looks like good alternative
> > too but here I just fail to decide on relevant naming.
> 
> Just bcmamba / bcmaxi?

Do bcm make any other (different) busses that would warrant a more
specific name, hinting somehow at the wireless cards specifically?

Or is it just cool to have a short name? Me I always like short names.


//Peter

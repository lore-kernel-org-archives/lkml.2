Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab0KLNGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:06:05 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:46327 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0KLNGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:06:01 -0500
X-AuditID: c1b4fb39-b7b54ae000003464-ac-4cdd3bb827ca
From: Harald Gustafsson <harald.gustafsson@ericsson.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Linus Walleij <linus.ml.walleij@gmail.com>,
        Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rickard ANDERSSON <Rickard.Andersson@stericsson.com>
Date: Fri, 12 Nov 2010 14:05:59 +0100
Subject: RE: [PATCH] [ARM] twd: Allow twd rescaling to match cpu frequency
Thread-Topic: [PATCH] [ARM] twd: Allow twd rescaling to match cpu frequency
Thread-Index: AcuCaWb6999dqclKQeGaOzUKMCYuzwAABthw
Message-ID: <2D4BBBBAD3C3714F8E8675F927E908210A210908@ESESSCMS0361.eemea.ericsson.se>
References: <1283396674-4865-1-git-send-email-ccross@android.com>
 <AANLkTinsRCinLdhq1xj0tx09Jb=Tohdbd7PUD=ae1q3m@mail.gmail.com>
 <DB5ED9F94071134F8D813944A461CF1A0196031CBA@ESESSCMS0361.eemea.ericsson.se>
 <20101112125901.GA3619@n2100.arm.linux.org.uk>
In-Reply-To: <20101112125901.GA3619@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Don't forget the other patches to make this work:
> > 
> > [ARM] twd: Always calibrate local timer [ARM] twd: Fix updating 
> > control register in set_mode [ARM] twd: Fix prescaler 
> getting cleared 
> > by set_mode
> 
> ... which have never been posted to this mailing list, so no 
> one here knows of them.

They are on the tegra branch git also authored by Colin. So I would suggest that Colin make all the changes into a new patch.

http://android.git.kernel.org/?p=kernel%2Ftegra.git&a=search&h=refs%2Fheads%2Flinux-tegra-2.6.35&st=commit&s=twd

/Harald
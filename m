Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab0IOLGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:06:32 -0400
Received: from galiil.marvell.com ([199.203.130.254]:3607 "EHLO
	galiil.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0IOLGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:06:30 -0400
From: Saeed Bishara <saeed@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
CC: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Sep 2010 13:06:26 +0300
Subject: RE: [PATCH] mmc: Add architecture dependency for Marvell SoC
 controller
Thread-Topic: [PATCH] mmc: Add architecture dependency for Marvell SoC
 controller
Thread-Index: ActUxSoQvBoSb+gvQYGpaGTHY28PPwAADJ9w
Message-ID: <FCBE654890C0334289D0AD3AF4EF009FD18EE74AC7@IL-MB01.marvell.com>
References: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100914190549.GA21918@void.printf.net>
 <20100915094006.GA21620@sirena.org.uk>
 <FCBE654890C0334289D0AD3AF4EF009FD18EE74AA8@IL-MB01.marvell.com>
 <20100915110001.GA4254@rakim.wolfsonmicro.main>
In-Reply-To: <20100915110001.GA4254@rakim.wolfsonmicro.main>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
>Which CPUs does the driver actually support?  The Kconfig and 
>commit log
>just say "Marvell" so I went for the conservative option and included
>all Marvell CPUs I was aware of.
The Marvell Dove SoC includes this device, this SoC defined by ARCH_DOVE
I guess it found also only on mmp (defined by ARCH_MMP), Haojian, can you confirm?
saeed
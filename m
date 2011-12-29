Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1L2D3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 22:29:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40812 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1L2D3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 22:29:38 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-17-4efbdea1cfd4
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Denis Kuzmenko'" <linux@solonet.org.ua>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Joe Perches'" <joe@perches.com>
References: <4EE7E0E7.1020802@solonet.org.ua>
 <063a01ccbfac$498513c0$dc8f3b40$%kim@samsung.com>
 <4EFB851F.9080805@solonet.org.ua> <20111229015640.GB4839@sirena.org.uk>
In-reply-to: <20111229015640.GB4839@sirena.org.uk>
Subject: RE: [PATCH v4] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib. Fix error disabling pull during probe.
Date: Thu, 29 Dec 2011 12:29:36 +0900
Message-id: <028601ccc5da$1734a410$459dec30$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczFzR6lwwdDSKBrSuSPAPF9DKG7EgABGZBg
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> 
> On Wed, Dec 28, 2011 at 11:07:43PM +0200, Denis Kuzmenko wrote:
> > On 12/21/2011 08:46 AM, Kukjin Kim wrote:
> > > Denis Kuzmenko wrote:
> 
> > >> Make s3c24xx LEDS driver use gpiolib. Fix error disabling pull during
> > >> probe.
> 
> > >> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> 
> > > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> 
> > > Richard, I think, this should be handled in your tree.
> 
> > ping Richard
> 
> Take a look at the git logs - Richard hasn't been actively maintaining a
> tree for the LEDs for some time now.

Hmm, ok. If we can't get his response before release 3.2, I will try to send
this via samsung tree.

Thanks all.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


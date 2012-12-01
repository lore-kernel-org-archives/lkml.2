Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2LASVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:21:13 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56980 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750Ab2LASVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:21:12 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX181SJyIJp8J1pFeInm40CJePGSuSeUuSSQ=
Date: Sat, 1 Dec 2012 13:21:08 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: Dove: Add pinctrl clock to DT
Message-ID: <20121201182108.GH12509@titan.lakedaemon.net>
References: <20121125152845.GV15800@titan.lakedaemon.net>
 <1353921525-25163-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <CACRpkdZcHsvSG-vfynd0jYrs0kVYqPsgtroSrQdz4yDZexQZjA@mail.gmail.com>
 <20121201181313.GF12509@titan.lakedaemon.net>
 <50BA495B.3010008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BA495B.3010008@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 07:15:55PM +0100, Sebastian Hesselbarth wrote:
> On 12/01/2012 07:13 PM, Jason Cooper wrote:
> >On Sat, Dec 01, 2012 at 06:07:06PM +0100, Linus Walleij wrote:
> >>On Mon, Nov 26, 2012 at 10:18 AM, Sebastian Hesselbarth
> >><sebastian.hesselbarth@gmail.com>  wrote:
> >>
> >>>During merge of the mvebu patches a clock gate for pinctrl was
> >>>lost. This patch just readds the clock gate.
> >>>
> >>>Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> >>
> >>Acked-by: Linus Walleij<linus.walleij@linaro.org>
> >>
> >>So who's supposed to merge this patch? Me? The MVEBU-maintainer?
> >
> >I'll take it and merge it in once v3.8-rc1 drops.
> 
> Linus, Jason,
> 
> I agree to take it through Jason's tree but please take v2 of
> the patch as there has been a small change in one of the patches.

Yes, I have it flagged.

thx,

Jason.

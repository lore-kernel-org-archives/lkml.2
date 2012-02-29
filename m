Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2B2RnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:43:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14906 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2B2RnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:43:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 29 Feb 2012 09:43:01 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 09:42:59 -0800
Subject: RE: [PATCH V2 0/6] pinctrl: API rework, pinconfig in mapping table,
 ...
Thread-Topic: [PATCH V2 0/6] pinctrl: API rework, pinconfig in mapping
 table, ...
Thread-Index: Acz3AaPYx0qIx8YvRnS6NUpBt+fboQAB8fag
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF209F@HQMAIL01.nvidia.com>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
 <CACRpkdbtH7edRVc=BmCncabMzQ=OB8eQAYju3Aoh-zSnFGQ6sA@mail.gmail.com>
In-Reply-To: <CACRpkdbtH7edRVc=BmCncabMzQ=OB8eQAYju3Aoh-zSnFGQ6sA@mail.gmail.com>
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

Linus Walleij wrote at Wednesday, February 29, 2012 9:46 AM:
> On Tue, Feb 28, 2012 at 9:27 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > This is the current set of patches I have outstanding for pinctrl.
> 
> Thanks, now the problem is that I think this is based on top of
> the other two patches, which happen to break U300 so I cannot
> test it :-(

I think this series will unbreak U300, i.e. if you apply everything
it'll all work fine? Of course, git bisect isn't maintained, so I still
need to rework the series as I mentioned in my previous email.

> It'd be great if you could resolve the hogging issue in the other
> patch set and put them as patch 1 & 2 of this patch set
> so I have the whole picture and can proceed from there.

OK.

-- 
nvpublic


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2BWQrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:47:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9379 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2BWQrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:47:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 23 Feb 2012 08:46:53 -0800
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
Date: Thu, 23 Feb 2012 08:46:51 -0800
Subject: RE: [PATCH 19/20] pinctrl: API changes to support multiple states
 per device
Thread-Topic: [PATCH 19/20] pinctrl: API changes to support multiple states
 per device
Thread-Index: Aczx76csBTc0kLyTR4yD0WY6xflXtwAWqTeQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC976@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-20-git-send-email-swarren@nvidia.com>
 <CACRpkdZQhJ9hBxD93FHjpCngugTZ2EFgJFwWObGd1YmEtfnxFA@mail.gmail.com>
In-Reply-To: <CACRpkdZQhJ9hBxD93FHjpCngugTZ2EFgJFwWObGd1YmEtfnxFA@mail.gmail.com>
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

Linus Walleij wrote at Wednesday, February 22, 2012 10:55 PM:
> On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

...
> This is looking real good. I think recent discussion with Russell
> also ironed out the problems with potential gpio interaction.

Hmm. I guess I need to go re-read that then; my impression was that we
hadn't really reached a solid conclusion yet.

...
> Please move this patch as far to the head of the series as possible
> so we can get it in, I guess you need the state lookup in struct pinctrl
> to proceed but could we e.g. puy the locking changes after this?

The main reason I wrote the patches like the locking patch was due to
issues I found when working on these two main patches. I'm not sure that
these later patches would work completely correctly without the locking
rework first...

-- 
nvpublic


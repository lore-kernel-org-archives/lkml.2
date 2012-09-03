Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2ICJcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:32:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56700 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2ICJcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <50431871.1030507@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1345623750-10645-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<5035445B.6000500@wwwdotorg.org>
	<CABJ1b_Tdr80DGqb-FRzwDbF3m7g6fBguk5GtRAfRUYx5Sqy_cA@mail.gmail.com>
	<50366E44.4030606@wwwdotorg.org>
	<50369305.6050304@gmail.com>
	<50369FEE.8000003@wwwdotorg.org>
	<5036B639.20608@gmail.com>
	<5036F651.4020700@wwwdotorg.org>
	<5038F50E.7030807@gmail.com>
	<503AF8B4.1070206@wwwdotorg.org>
	<CACRpkdYsPadKr1i8m5cCAFUUvJYUnLmc3j8evKM_6rPU5oGzRg@mail.gmail.com>
	<50431871.1030507@gmail.com>
Date: Mon, 3 Sep 2012 11:32:12 +0200
Message-ID: <CACRpkdaHm9YZjM7GzZ-VEPgQfn86XrjdO1ZYWMuohCQH1PshZw@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:27 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> there is a v3 of the patch under internal review right now.

OK I'll review as you send it out. Will look through the v2 patches to
see if I missed some comment.

> I know Stephen will not like it, but I decided not to have the list of
> functions passed statically from the SoC specific part but generate it
> out of pingroups during probe().

Well, Tony's driver does even nastier things so we need to agree
to disagree on this point. I for one can live with it.

Yours,
Linus Walleij

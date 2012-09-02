Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2IBHas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:30:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39982 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab2IBHaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <503AF8B4.1070206@wwwdotorg.org>
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
Date: Sun, 2 Sep 2012 09:30:45 +0200
Message-ID: <CACRpkdYsPadKr1i8m5cCAFUUvJYUnLmc3j8evKM_6rPU5oGzRg@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
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

On Mon, Aug 27, 2012 at 6:33 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/25/2012 08:53 AM, Sebastian Hesselbarth wrote:
>>
>> now I do understand but in the current driver we pass pingroups associated
>> with the available functions, i.e. "mpp2" with "uart1", "uart2",
>> "sdio0", aso.
>> IMHO for the above three functions it would be better to have functions
>> associated
>> with the corresponding groups, i.e. "uart1" with "mpp_uart1", "mpp2",
>> "mpp3", aso.
>
> The pinctrl subsystem does expect a list of functions, and for each
> function, a list of the groups where it can be selected. I admit that
> when I think about this, it's slightly backward, since HW typically has
> a list of pins/groups, and for each, a certain set of functions can be
> selected. Oh well...

I agree that this is how we engineered it, would it create big hassles
for you to fix up the driver so it's the other way around Sebastian?

I understand that the driver is perfectly working as it is, but from
a subsystem maintainer point of view it is annoying if one driver
turns the concepts around and it gets hard to maintain.

Yours,
Linus Walleij

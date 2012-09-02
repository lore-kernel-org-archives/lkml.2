Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab2IBI1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 04:27:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38036 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2IBI1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 04:27:34 -0400
Message-ID: <50431871.1030507@gmail.com>
Date: Sun, 02 Sep 2012 10:27:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>	<1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>	<1345623750-10645-2-git-send-email-sebastian.hesselbarth@gmail.com>	<5035445B.6000500@wwwdotorg.org>	<CABJ1b_Tdr80DGqb-FRzwDbF3m7g6fBguk5GtRAfRUYx5Sqy_cA@mail.gmail.com>	<50366E44.4030606@wwwdotorg.org>	<50369305.6050304@gmail.com>	<50369FEE.8000003@wwwdotorg.org>	<5036B639.20608@gmail.com>	<5036F651.4020700@wwwdotorg.org>	<5038F50E.7030807@gmail.com>	<503AF8B4.1070206@wwwdotorg.org> <CACRpkdYsPadKr1i8m5cCAFUUvJYUnLmc3j8evKM_6rPU5oGzRg@mail.gmail.com>
In-Reply-To: <CACRpkdYsPadKr1i8m5cCAFUUvJYUnLmc3j8evKM_6rPU5oGzRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2012 09:30 AM, Linus Walleij wrote:
> On Mon, Aug 27, 2012 at 6:33 AM, Stephen Warren<swarren@wwwdotorg.org>  wrote:
>> The pinctrl subsystem does expect a list of functions, and for each
>> function, a list of the groups where it can be selected. I admit that
>> when I think about this, it's slightly backward, since HW typically has
>> a list of pins/groups, and for each, a certain set of functions can be
>> selected. Oh well...
>
> I agree that this is how we engineered it, would it create big hassles
> for you to fix up the driver so it's the other way around Sebastian?
>
> I understand that the driver is perfectly working as it is, but from
> a subsystem maintainer point of view it is annoying if one driver
> turns the concepts around and it gets hard to maintain.

Stephen, Linus, Jason,

there is a v3 of the patch under internal review right now.

I know Stephen will not like it, but I decided not to have the list of
functions passed statically from the SoC specific part but generate it
out of pingroups during probe().

As soon as I have confirmation that it still works on the other SoCs,
I will send the updated patches for public review.

Maybe Jason can also comment on what branch he wants to have it based
on, as we all agreed to get it through the Marvell tree.

Sebastian

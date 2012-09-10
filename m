Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab2IJP50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:57:26 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54842 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2IJP5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:57:24 -0400
Message-ID: <504E0DDD.1050000@gmail.com>
Date: Mon, 10 Sep 2012 17:57:17 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/9] pinctrl: mvebu: pinctrl driver
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>	<1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkda0AxcwqeBy2rZXRymq5iYxbdYWQsHtALHMObYqTaKyKw@mail.gmail.com>
In-Reply-To: <CACRpkda0AxcwqeBy2rZXRymq5iYxbdYWQsHtALHMObYqTaKyKw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 05:45 PM, Linus Walleij wrote:
> This all looks good now, will this be pushed through some ARM SoC
> tree along with Marvell changes or do you want me to take it all
> through the pinctrl tree?

Linus,

thanks for review and ACKs. Jason Cooper will take it through Marvell
tree.

Sebastian

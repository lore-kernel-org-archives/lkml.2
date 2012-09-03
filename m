Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab2ICTrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:47:51 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:38708 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752441Ab2ICTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:47:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 173.50.127.139
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19zt37cZxsTmVjMn08Rv3t3p67Os2NQSRs=
Date: Mon, 3 Sep 2012 15:47:35 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Andrew Lunn <andrew@lunn.ch>,
        Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
Message-ID: <20120903194735.GO19437@titan.lakedaemon.net>
References: <CABJ1b_Tdr80DGqb-FRzwDbF3m7g6fBguk5GtRAfRUYx5Sqy_cA@mail.gmail.com>
 <50366E44.4030606@wwwdotorg.org>
 <50369305.6050304@gmail.com>
 <50369FEE.8000003@wwwdotorg.org>
 <5036B639.20608@gmail.com>
 <5036F651.4020700@wwwdotorg.org>
 <5038F50E.7030807@gmail.com>
 <503AF8B4.1070206@wwwdotorg.org>
 <CACRpkdYsPadKr1i8m5cCAFUUvJYUnLmc3j8evKM_6rPU5oGzRg@mail.gmail.com>
 <50431871.1030507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50431871.1030507@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 10:27:29AM +0200, Sebastian Hesselbarth wrote:
> Maybe Jason can also comment on what branch he wants to have it based
> on, as we all agreed to get it through the Marvell tree.

Please base against:

git://git.infradead.org/users/jcooper/linux.git boards-for-v3.7-v2

thx,

Jason.

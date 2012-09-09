Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2IJAlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:41:45 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:30843 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755700Ab2IJAln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:41:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 173.50.127.139
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/QyCcCkldDVbgcXnMHxRnV6YZQVkQD0iU=
Date: Sun, 9 Sep 2012 15:56:10 -0400
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
Message-ID: <20120909195610.GK4575@titan.lakedaemon.net>
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
> there is a v3 of the patch under internal review right now.

Sebastian,

What is the status of v3?  I'd like to get it (and gpio, which depends
on this work) in for v3.7, but it's getting close...

thx,

Jason.

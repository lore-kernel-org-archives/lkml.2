Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3AGQUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:20:44 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:50773 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753692Ab3AGQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:20:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/niS85t6qyyss1nYijb1ff3/rQN4lwY6w=
Date: Mon, 7 Jan 2013 11:20:34 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Axel Lin <axel.lin@ingics.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] ARM: Dove: Add pinctrl clock to DT
Message-ID: <20130107162034.GH5075@titan.lakedaemon.net>
References: <1353921525-25163-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1353957399-28799-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353957399-28799-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 08:16:38PM +0100, Sebastian Hesselbarth wrote:
> During merge of the mvebu patches a clock gate for pinctrl was
> lost. This patch just readds the clock gate.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Cc: Axel Lin <axel.lin@ingics.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/boot/dts/dove.dtsi |    1 +
>  1 file changed, 1 insertion(+)

Both (v2) applied to mvebu/fixes

thx,

Jason.

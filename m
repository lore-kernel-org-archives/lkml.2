Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1LFV4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:56:14 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:43603 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1LFV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:56:13 -0500
X-Auth-Info: vzbUeQPNRxh6zpwH/U6Zpuc6Ez0vs0eQ7Dy33iOmI4Q=
To: Wolfram Sang <w.sang@pengutronix.de>
cc: Heiko Schocher <hs@denx.de>, Vitaly Bordug <vbordug@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
MIME-Version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
In-reply-to: <20111206215056.GD14154@pengutronix.de>
References: <1322991921-21096-1-git-send-email-hs@denx.de> <20111204114741.GA5788@pengutronix.de> <4EDCD7B2.5030409@denx.de> <20111206215056.GD14154@pengutronix.de>
Comments: In-reply-to Wolfram Sang <w.sang@pengutronix.de>
   message dated "Tue, 06 Dec 2011 22:50:56 +0100."
Date: Tue, 06 Dec 2011 22:56:09 +0100
Message-Id: <20111206215609.5D1FF1A32820@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wolfram,

In message <20111206215056.GD14154@pengutronix.de> you wrote:
> 
> bootcount itself is not a device. It is a feature of certain devices. And that
> needs to be implemented; possibly generic enough that it can work for register
> based, i2c based, and so forth, accesses.

If "boot counter" is not a good name for such a device, then what name
would you suggest?

Or do you think a counter (which can be implemented in a number of
different ways, depending on hardware specifics) is not a device?
What would be such a device, then?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"How is this place run - is it an anarchy?"
"No, I wouldn't say so; it is not that well organised..."

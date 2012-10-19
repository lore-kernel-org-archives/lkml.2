Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2JSSK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:10:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19402 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133Ab2JSSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:10:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JBSPGpTJVpUGEi4XCo9Cp
Date: Fri, 19 Oct 2012 11:10:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Jean Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: [PATCH v2] pinctrl: reserve pins when states are activated
Message-ID: <20121019181019.GP4730@atomide.com>
References: <1350651909-5337-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350651909-5337-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@stericsson.com> [121019 06:09]:
> 
> Instead: let use reserve the pins when the state is activated
> and drop them when the state is disabled, i.e. when we move to
> another state. This way different devices/functions can use the
> same pins at different times.

Hmm doesn't this mean that we are now doing lots of extra
reserving and dropping of pins? Performance is important from
latency point of view for cases where we need to remux pins
constantly runtime PM.

Regards,

Tony

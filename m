Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab1ECBxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:53:38 -0400
Received: from anumail9.anu.edu.au ([130.56.64.136]:40890 "EHLO
	anumail9.anu.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1ECBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:53:37 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 21:53:36 EDT
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 3 May 2011 11:47:59 +1000
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Transfer-Encoding: 7bit
Message-Id: <975406B8-5A4D-4C71-85D0-A4352069CB6D@niasdigital.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
To: Linus Walleij <linus.walleij@stericsson.com>
X-Mailer: Apple Mail (2.1084)
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.3.13616 internal
X-PMX-Outbound: anu.edu.au
X-PMX-Info: external-sender
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_1099 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MIME_VERSION_APPLEMAIL 0, __MSGID_APPLEMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT_APPLEMAIL 0, __X_MAILER_APPLEMAIL 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/05/2011, at 5:16 AM, Linus Walleij wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This creates a subsystem for handling of pinmux devices. These are
> devices that enable and disable groups of pins on primarily PGA and
> BGA type of chip packages and common in embedded systems.
> 
> This is being done to depopulate the arch/arm/* directory of such
> custom drivers and try to abstract the infrastructure they all
> need. See the Documentation/pinmux.txt file that is part of this
> patch for more details.

Haven't reviewed the actual code but at an interface level it seems
sane.  It'd be nice to actually implement a driver for some nutbars SoC
and make sure it all shakes out but in the first instance I can't see
any problems.

Leaving it orthogonal to gpio is a great move conceptually and if it does
need to be tied back to the gpio_request() interface later then, well,
we'll cross that bridge when we come to it.

Thanks for your work in this area, looking good.

	--Ben.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab0FGFoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:44:13 -0400
Received: from void.printf.net ([89.145.121.20]:33099 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab0FGFoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:44:12 -0400
From: Chris Ball <cjb@laptop.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc: fix mmc card disappearence on resume on ricoh mmc controllers
References: <1275859475.3151.4.camel@maxim-laptop>
	<1275859731-2898-2-git-send-email-maximlevitsky@gmail.com>
	<20100606232313.GA5444@void.printf.net>
	<1275870795.24091.4.camel@maxim-laptop>
Date: Mon, 07 Jun 2010 01:47:00 -0400
In-Reply-To: <1275870795.24091.4.camel@maxim-laptop> (Maxim Levitsky's message
	of "Mon, 07 Jun 2010 03:33:15 +0300")
Message-ID: <m3bpbn1jjf.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxim,

   >> It looks like your editor is set to four-space instead of
   >> eight-space tab characters, else you wouldn't be using so
   >> many tabs here.

   > Nope, I think indention is right here.
   >
   > the break is inside 'if' condition.

Please look again, I think you're mistaken.  For example, why do you
use seven tab characters for the "& SDHCI_CARD_PRESENT" after the if
line?  With eight-space tabs, it looks like this (converted to
spaces):

+                       if (sdhci_readl(host, SDHCI_PRESENT_STATE)
+                                                       & SDHCI_CARD_PRESENT) {

See http://lkml.org/lkml/2010/6/6/171 for an eight-space tabs
rendering of the patch.

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child

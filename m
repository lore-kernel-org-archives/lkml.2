Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0HIHbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:31:51 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59215 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab0HIHbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:31:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/srwnC58WuvYCaS7Dx+k+M
Date: Mon, 9 Aug 2010 10:31:43 +0300
From: Tony Lindgren <tony@atomide.com>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Subject: Re: [PATCH 1/2] mfd: menelaus: Fix mmc slot 2 misconfiguration
Message-ID: <20100809073143.GA32480@atomide.com>
References: <1281287124-26693-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281287124-26693-1-git-send-email-jhnikula@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jarkko Nikula <jhnikula@gmail.com> [100808 19:57]:
>
> Tested on N810. Integrated eMMC on N810 started to work with this patch.

Ah great, good to hear! I've been wondering for a while how come only
the external MMC worked.

Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2EHXYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:24:52 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:16695 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EHXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:24:51 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+RSh9gG5enmEPWfIoar8ct
Date: Tue, 8 May 2012 16:24:49 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mans Rullgard <mans@mansr.com>
Cc: linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: craneboard: register emac device
Message-ID: <20120508232448.GT5088@atomide.com>
References: <1334858181-7232-1-git-send-email-mans@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334858181-7232-1-git-send-email-mans@mansr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mans Rullgard <mans@mansr.com> [120419 11:02]:
> This adds the required am35xx_emac_init() call to the craneboard init
> function.

Thanks applying into board branch.

Tony

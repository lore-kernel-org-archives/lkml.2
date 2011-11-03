Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1KCWPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:15:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60025 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1KCWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:15:08 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+tR1ajgd3Dm0ussVLNdZiv
Date: Thu, 3 Nov 2011 15:15:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Michael Opdenacker <michael.opdenacker@linaro.org>
Cc: linux@arm.linux.org.uk, khilman@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH 1/1] arm: omap: removed obsolete IRQF_DISABLED
Message-ID: <20111103221501.GD31337@atomide.com>
References: <1318139198-6865-1-git-send-email-michael.opdenacker@linaro.org>
 <1318139198-6865-2-git-send-email-michael.opdenacker@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318139198-6865-2-git-send-email-michael.opdenacker@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Opdenacker <michael.opdenacker@linaro.org> [111008 22:13]:
> This flag is a NOOP since 2.6.36

Looks like there's an ARM wide patch to do this with
"[PATCH 03/55] arm: irq: Remove IRQF_DISABLED".

Regards,

Tony

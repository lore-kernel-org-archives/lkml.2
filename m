Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab0LRCFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 21:05:24 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:22418 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab0LRCFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 21:05:20 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/UHp5sPiHpfzJak52P5aZ2
Date: Fri, 17 Dec 2010 18:05:04 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Marek Belisko <marek.belisko@open-nandra.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap1: pm_bus: Fix compilation warning.
Message-ID: <20101218020504.GM5941@atomide.com>
References: <1291641828-19909-1-git-send-email-marek.belisko@open-nandra.com>
 <87lj41jk8p.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lj41jk8p.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@deeprootsystems.com> [101207 14:13]:
> Marek Belisko <marek.belisko@open-nandra.com> writes:
> 
> > Fix following compilation warning:
> > arch/arm/mach-omap1/pm_bus.c: In function 'omap1_pm_runtime_resume':
> > arch/arm/mach-omap1/pm_bus.c:51: warning: unused variable 'ret'
> >
> > Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> 
> Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

Taking these except for the mailbox one which is already fixed.

Tony

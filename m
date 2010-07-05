Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab0GEIou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:44:50 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59938 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0GEIot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:44:49 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Buf/eJRCsGWeTRcss/wMq
Date: Mon, 5 Jul 2010 11:44:50 +0300
From: Tony Lindgren <tony@atomide.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
       Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 18/33] Removing dead OMAP_ARM_96MHZ
Message-ID: <20100705084448.GJ15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <8304abb0dbda307c488b6fe2b3cc8df3c9909eb6.1277911346.git.siccegge@cs.fau.de>
 <201006302025.14881.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006302025.14881.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Vasut <marek.vasut@gmail.com> [100630 21:21]:
> Dne St 30. června 2010 17:59:45 Christoph Egger napsal(a):
> > OMAP_ARM_96MHZ doesn't exist in Kconfig, therefore removing all
> > references for it from the source code.
> 
> I'd be for adding it to Kconfig rather than removing from here

Looks like Paul has queued a patch to do this.

Tony

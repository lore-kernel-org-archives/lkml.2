Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0GEIee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:34:34 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62597 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0GEIec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:34:32 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/yNozk0ohiy0SvAHDLLYCs
Date: Mon, 5 Jul 2010 11:33:48 +0300
From: Tony Lindgren <tony@atomide.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
       Russell King <linux@arm.linux.org.uk>, Kalle Valo <kalle.valo@iki.fi>,
       Ladislav Michl <ladis@linux-mips.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 17/33] Removing dead SX1_OLD_FLASH
Message-ID: <20100705083346.GI15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <5b21086199b139a61888c16e92d3efe6b205dae2.1277911346.git.siccegge@cs.fau.de>
 <201006302024.47025.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006302024.47025.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Vasut <marek.vasut@gmail.com> [100630 21:21]:
> Dne St 30. června 2010 17:59:25 Christoph Egger napsal(a):
> > SX1_OLD_FLASH doesn't exist in Kconfig, therefore removing all
> > references for it from the source code.
> 
> There were two models of the phone made, you can toggle between old and new 
> version. Maybe better documentation won't hurt.

Sounds like this should be done dynamically based on omap_rev,
or some cmdline option from the bootloader? Not applying this
one.

Tony

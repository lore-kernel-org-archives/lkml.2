Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2CEWM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:12:56 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:42665 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab2CEWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:12:54 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+FoEuaJx9fgJPNga/kV8tC
Date: Mon, 5 Mar 2012 14:12:47 -0800
From: Tony Lindgren <tony@atomide.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Paul Walmsley <paul@pwsan.com>, Danny Kukawka <dkukawka@suse.de>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/plat-omap/clock.c: included linux/debugfs.h
 twice
Message-ID: <20120305221247.GZ12083@atomide.com>
References: <1329403433-32327-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329403433-32327-1-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Danny Kukawka <danny.kukawka@bisect.de> [120216 06:12]:
> arch/arm/plat-omap/clock.c: included 'linux/debugfs.h' twice,
> remove the duplicate.

Thanks, applying into fixes-non-critical-part2.

Regards,

Tony

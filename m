Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2JHVIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:08:06 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27274 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999Ab2JHVID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:08:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+5OdD8e7/W4PtIwJZKaMOO
Date: Mon, 8 Oct 2012 14:07:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: OMAP: rx51: Fix a section mismatch warn
Message-ID: <20121008210759.GG13011@atomide.com>
References: <1347460624-25259-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347460624-25259-1-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shubhrajyoti D <shubhrajyoti@ti.com> [120912 07:38]:
> rx51_si4713_dev is referenced only from rx51_init_si4713.
> So the memory for rx51_si4713_dev can be safely freed after init.
> Also it references rx51_si4713_board_info which is __initdata_or_module.

Thanks applying into fixes.

Tony

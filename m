Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1BUSvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 13:51:55 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47301 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab1BUSvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 13:51:53 -0500
Subject: Re: [PATCH] Make clocksource name const
From: john stultz <johnstul@us.ibm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110219153450.GI29493@n2100.arm.linux.org.uk>
References: <20110219153450.GI29493@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 10:51:48 -0800
Message-ID: <1298314308.4222.2.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-19 at 15:34 +0000, Russell King - ARM Linux wrote:
> As nothing should be writing to the clocksource name string, make the
> clocksource name pointer const.  Build-tested on ARM Versatile Express.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Sounds good. I'll add it to my queue for 2.6.39

Acked-by: John Stultz <johnstul@us.ibm.com>

thanks
-john


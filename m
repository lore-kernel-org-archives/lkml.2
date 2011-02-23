Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1BWWR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:17:57 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55827 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab1BWWRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:17:55 -0500
Subject: Re: [PATCH 4/6] sparc: convert to clocksource_register_hz/khz
From: john stultz <johnstul@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20110223.132629.104051788.davem@davemloft.net>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
	 <1297838092-22989-5-git-send-email-johnstul@us.ibm.com>
	 <20110223.132629.104051788.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 14:17:51 -0800
Message-ID: <1298499471.9215.180.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 13:26 -0800, David Miller wrote:
> From: John Stultz <johnstul@us.ibm.com>
> Date: Tue, 15 Feb 2011 22:34:50 -0800
> 
> > This converts the sparc clocksources to use clocksource_register_hz/khz
> > 
> > This is untested, so any assistance in testing would be appreciated!
> > 
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> Applied, but please CC: sparclinux@vger.kernel.org for sparc patches.

Thanks! I'll do that in the future!
-john



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1CCUNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:13:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52572
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932248Ab1CCUNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:13:07 -0500
Date: Thu, 03 Mar 2011 12:13:43 -0800 (PST)
Message-Id: <20110303.121343.28802720.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, cl@linux.com,
        john.stultz@linaro.org, khc@pm.waw.pl, peterz@infradead.org,
        giometti@linux.it, tglx@linutronix.de, benh@kernel.crashing.org,
        vapier@gentoo.org, paulus@samba.org, linux@arm.linux.org.uk
Subject: Re: [PATCH V12 0/4] ptp: IEEE 1588 hardware clock support
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1298878618.git.richard.cochran@omicron.at>
References: <cover.1298878618.git.richard.cochran@omicron.at>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Mon, 28 Feb 2011 08:57:03 +0100

> This really might be the last review of the PTP hardware clock patch
> series. These patches apply on top of the timers/core branch in the
> tip tree.

I'm find with the networking portions so:

Acked-by: David S. Miller <davem@davemloft.net>

I am assuming these will be pushed through the timers/core branch
since there are dependencies.

Thanks.

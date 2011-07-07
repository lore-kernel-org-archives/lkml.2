Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1GGMji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:39:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49193 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab1GGMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:39:37 -0400
Date: Thu, 7 Jul 2011 13:39:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Wim Van Sebroeck <wim@iguana.be>,
        Marc Zyngier <marc.zyngier@arm.com>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/4] ARM: smp_twd: Fix typo in 'twd_timer_rate'
	printing
Message-ID: <20110707123907.GP8286@n2100.arm.linux.org.uk>
References: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com> <1310041396-2461-1-git-send-email-vkuzmichev@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310041396-2461-1-git-send-email-vkuzmichev@mvista.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 04:23:13PM +0400, Vitaly Kuzmichev wrote:
> To get hundredths of MHz the rate needs to be divided by 10'000.
> Here is an example:
>  twd_timer_rate = 123456789
>  Before the patch:
>     twd_timer_rate / 1000000 = 123
>     (twd_timer_rate / 1000000) % 100 = 23
>     Result: 123.23MHz.
>  After being fixed:
>     twd_timer_rate / 1000000 = 123
>     (twd_timer_rate / 10000) % 100 = 45
>     Result: 123.45MHz.
> 
> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>

-> patch system please.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1AHAJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 19:09:30 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:59463 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1AHAJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:09:29 -0500
Date: Sat, 8 Jan 2011 01:09:01 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <benh@debian.org>, David Miller <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110108000901.GA2133@electric-eye.fr.zoreil.com>
References: <20110106.122003.233698077.davem@davemloft.net> <AANLkTi=7=_FyVsjA3vKEpg8RwfC=m-8QGfqa6ctxQday@mail.gmail.com> <20110107190656.GQ3702@decadent.org.uk> <AANLkTikwrHoOY4wvUp1qn-OT=EjZesSNR29US1ERc0o2@mail.gmail.com> <20110107215505.GA1892@electric-eye.fr.zoreil.com> <AANLkTinANp+Jp8TPKzii6iZLUFpMyrXhmxYr42nZrXQU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinANp+Jp8TPKzii6iZLUFpMyrXhmxYr42nZrXQU@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> :
[...]
> Hmm. I never even waited for 60 seconds. Maybe my boot would have
> continued after the delay.

The 60 seconds delay is here :

drivers/base/firmware_class.c
[...]
static int loading_timeout = 60;        /* In seconds */

It can be read and set through sysfs.

I'll give a try at moving the request-firmware dependent stuff to
device-open time in drivers/net/r8169.c tomorrow morning. It's friday.

-- 
Ueimor

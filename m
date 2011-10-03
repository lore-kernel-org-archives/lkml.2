Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1JCP5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:57:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab1JCP5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:57:42 -0400
Date: Mon, 3 Oct 2011 11:56:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org
Subject: Re: [V7][PATCH 0/6] x86, nmi: new NMI handling routines
Message-ID: <20111003155655.GG5795@redhat.com>
References: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
 <1317657158.20367.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317657158.20367.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:52:38PM +0200, Peter Zijlstra wrote:
> 
> Also fixed:
> 
> drivers/char/ipmi/ipmi_watchdog.c: In function ‘ipmi_nmi’:
> drivers/char/ipmi/ipmi_watchdog.c:1091: error: ‘NMI_HANDLED’ undeclared (first use in this function)
> drivers/char/ipmi/ipmi_watchdog.c:1091: error: (Each undeclared identifier is reported only once
> drivers/char/ipmi/ipmi_watchdog.c:1091: error: for each function it appears in.)
> drivers/char/ipmi/ipmi_watchdog.c:1096: error: ‘NMI_DONE’ undeclared (first use in this function)
> drivers/char/ipmi/ipmi_watchdog.c: In function ‘check_parms’:
> drivers/char/ipmi/ipmi_watchdog.c:1280: error: implicit declaration of function ‘register_nmi_handler’
> drivers/char/ipmi/ipmi_watchdog.c:1280: error: ‘NMI_UNKNOWN’ undeclared (first use in this function)
> drivers/char/ipmi/ipmi_watchdog.c:1289: error: implicit declaration of function ‘unregister_nmi_handler’
> drivers/char/ipmi/ipmi_watchdog.c: In function ‘ipmi_wdog_init’:
> drivers/char/ipmi/ipmi_watchdog.c:1327: error: ‘NMI_UNKNOWN’ undeclared (first use in this function)
> drivers/char/ipmi/ipmi_watchdog.c: In function ‘ipmi_wdog_exit’:
> drivers/char/ipmi/ipmi_watchdog.c:1348: error: ‘NMI_UNKNOWN’ undeclared (first use in this function)

Wow. Sorry about that.  I compiled my changes before I submitted.  I guess
next time I should 'make clean' before compiling to catch these.

I suck.

Cheers,
Don

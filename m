Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab0HUBEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 21:04:25 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38683 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0HUBEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 21:04:22 -0400
Subject: Re: [KVM timekeeping 17/35] Implement getnsboottime kernel API
From: john stultz <johnstul@us.ibm.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <4C6F235D.5040100@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
	 <1282291669-25709-18-git-send-email-zamsden@redhat.com>
	 <1282329594.3302.39.camel@localhost.localdomain>
	 <4C6F11D6.1050101@redhat.com>
	 <1282348958.28794.21.camel@localhost.localdomain>
	 <4C6F235D.5040100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 18:04:15 -0700
Message-ID: <1282352655.28794.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 14:52 -1000, Zachary Amsden wrote:
> I think gettimefromboot_ns() is a good descriptive name, but slightly 
> too long - it would ruin my indentation.  Perhaps getrealtime_ns()?

Sigh... So getrealtime_ns would probably be confused with
CLOCK_REALTIME, which is wall time.  :P

At this point it feels too nitpicky to suggest anything else, so go
ahead and use boottime_ns and we'll refine things if anyone actually
trips up on it.

thanks
-john



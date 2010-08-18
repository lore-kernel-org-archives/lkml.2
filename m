Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab0HRFDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:03:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:46449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0HRFDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:03:41 -0400
Subject: Re: 64-bit ppc rwsem (was: Re: [GIT] Sparc)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <1282106338.22370.151.camel@pasglop>
References: <20100817.180325.104051399.davem@davemloft.net>
	 <AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
	 <AANLkTimZ3rhX2AzPExEGfRCXiFNN-BGOWRKqL241-qNa@mail.gmail.com>
	 <20100817.191424.183031381.davem@davemloft.net>
	 <1282106338.22370.151.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 15:03:23 +1000
Message-ID: <1282107803.22370.173.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 14:38 +1000, Benjamin Herrenschmidt wrote:
> 
> Here's an untested patch for the folks on linuxppc-dev to look at,
> I'll
> review my own stuff & test tomorrow. 

Allright, gcc's being a pain, and atomics are a struct so we can't that
easily assign.

I tried various tricks but so far they didn't work. I'll have another
look tomorrow, but I may end up having to keep all the crap typecasts.

Cheers,
Ben.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0HKPv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:51:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43859 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab0HKPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:51:55 -0400
Date: Wed, 11 Aug 2010 08:51:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 11 (hpet)
Message-Id: <20100811085138.67782931.randy.dunlap@oracle.com>
In-Reply-To: <20100811140009.6ff33109.sfr@canb.auug.org.au>
References: <20100811140009.6ff33109.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 14:00:09 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> As the merge window is open, please do not add 2.6.37 material to your
> linux-next included trees until after 2.6.36-rc1.
> 
> Changes since 20100810:


on i386 (X86_32):

arch/x86/kernel/hpet.c:840: warning: integer overflow in expression

	hpet_freq = FSEC_PER_NSEC * NSEC_PER_SEC;



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

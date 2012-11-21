Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2KURrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:47:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab2KURrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:47:12 -0500
Date: Wed, 21 Nov 2012 12:46:55 -0500
From: Dave Jones <davej@redhat.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: pi futex oops in __lock_acquire
Message-ID: <20121121174655.GA25392@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <507F9944.50505@kernel.dk>
 <20121019052136.GA30852@redhat.com>
 <1350650972.30157.34.camel@twins>
 <20121023195026.GA2872@redhat.com>
 <20121024202411.GA20597@redhat.com>
 <5088C397.3000501@linux.intel.com>
 <20121120164637.GA19893@redhat.com>
 <50AC0DFA.3000103@linux.intel.com>
 <50AC20A5.8040500@linux.intel.com>
 <50AD1164.2000904@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AD1164.2000904@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 09:37:40AM -0800, Darren Hart wrote:
 > I've sent a patch to address this. It has now been running "trinity -c
 > futex" for about 12 hours. I haven't seen any more futex failures

Looks good here too.

 > but I
 > have seen a few OOMs. Is that expected from trinity?

Yeah, seems there's some leaks (both in trinity and the kernel).
Oddly enough someone else emailed me about that this morning, which
prompted me to write up this: http://codemonkey.org.uk/2012/11/21/fuzz-testing-oom-killer/
Which is just part of the problem. There are other issues too it seems. Fun.

	Dave


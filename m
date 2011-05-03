Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1ECSCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:02:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab1ECSCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:02:03 -0400
Date: Tue, 3 May 2011 09:01:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Sebastian =?iso-8859-1?Q?F=E4rber?= <faerber@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hard LOCKUP, maybe acpi related (present in 2.6.32 to 2.6.37,
 fixed in 2.6.38)
Message-ID: <20110503130123.GA23498@redhat.com>
References: <BANLkTikAun3_-WyKE0RJiXei=QGXQ1g+JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikAun3_-WyKE0RJiXei=QGXQ1g+JQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 12:50:35PM +0200, Sebastian Färber wrote:
> Hi,
> 
> I'm trying to track down a problem i have with newer hardware which seems
> fixed in 2.6.38.4 but which i can reproduce from 2.6.32 to 2.6.37
> I'm running a DEBUG Kernel with nmi_watchdog=1 and attached a backtrace
> of the lockup that happened on 2.6.37.6. I can also provide backtraces for
> 2.6.32 to 2.6.35 if necessary, they look very similar.

It looks like you are using the old nmi watchdog which may have given you
false positives.  Can you turn on the new nmi watchdog (for 2.6.36 or
later)?

CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y

and see if that gives a more meaningful backtrace?

Cheers,
Don

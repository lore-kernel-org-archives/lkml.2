Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1AVLT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:19:58 -0500
Received: from www17.your-server.de ([213.133.104.17]:41722 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1AVLT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:19:57 -0500
Subject: Re: 2.6.37-08009-ge6f597a "feels" slow - rhythmbox skips audio
From: Thomas Meyer <thomas@m3y3r.de>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ih73o4$gnf$1@dough.gmane.org>
References: <1295395790.3327.9.camel@localhost.localdomain>
	 <ih73o4$gnf$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Jan 2011 12:17:18 +0100
Message-ID: <1295695038.2120.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 19.01.2011, 08:33 -0800 schrieb walt:
> On 01/18/2011 04:09 PM, Thomas Meyer wrote:
> > hi,
> >
> > kernel version 2.6.37-08009-ge6f597a "feels" slow and background audio
> > skips/stalls when performing some cpu (and/or io?) intensive tasks like
> > a kernel compile or grepping for a string in the kernel source or
> > upgrading the system via yum upgrade.
> >
> > I didn't see this behaviour with 2.6.37 (and previous versions) on my UP
> > system.
> 
> I see the same on my UP machine (but not SMP) when using the new
> SCHED_AUTOGROUP feature.  Do you have that enabled?

Yes, I *had* SCHED_AUTOGROUP enabled. After disabling it, the machine is
back to normal speed.

kind regards
thomas

PS: CC me please as I'm not subscribed to the list.


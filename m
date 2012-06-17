Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2FQQr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 12:47:58 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35418 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab2FQQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 12:47:57 -0400
Date: Sun, 17 Jun 2012 11:47:51 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: John Stultz <johnstul@us.ibm.com>, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Dave Jones <davej@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
Message-ID: <20120617164751.GJ12429@burratino>
References: <4FDB8563.3030805@us.ibm.com>
 <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Fri, 2012-06-15 at 11:56 -0700, John Stultz wrote:

>> commit dd48d708ff3e917f6d6b6c2b696c3f18c019feed upstream.
[...]
> This doesn't apply to 3.2.y, unsurprisingly.  Let me know if there are
> any urgent leap second fixes that will be needed there.

6b43ae8a619d (ntp: Fix leap-second hrtimer livelock) sounds important,
but the patch depends on bd3312681f69 (ntp: Add ntp_lock to replace
xtime_locking) which does not have a commit message explaining its
purpose (and that patch in turn depends on ea7cf49a7633).

John, is that bug present in 3.2.y and 3.0.y, too?  Any hints for
fixing it?

Thanks,
Jonathan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0HTGbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 02:31:19 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42068 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750926Ab0HTGbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 02:31:16 -0400
Date: Fri, 20 Aug 2010 08:31:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-acpi@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fan runs full speed after S3 sometimes (regression)
Message-ID: <20100820063107.GB1607@ucw.cz>
References: <4C613619.30309@gmail.com>
 <4C619CF0.30609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C619CF0.30609@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-08-10 20:39:44, Jiri Slaby wrote:
> On 08/10/2010 01:20 PM, Jiri Slaby wrote:
> > Hi,
> > 
> > till I was running on 2.6.34-rc5-mm1 (mmotm) and earlier everything was
> > fine. Now, I'm running 2.6.35-rc6-mm1 (.35-rc5-mm1 was the same) and
> > sometimes when the computer (desktop) returns from S3, the CPU fan is
> > running at full speed making a big noise.
> 
> Just to add, full power cycle is needed to get rid of that. Warm reboot
> is not enough.

Seems like bios problem... Update bios?

> > I don't know how to debug that. Bisection is out of question -- it
> > happens once in 10 or 20 cases. There are no fan entries in /sys.

Well, doing 20 suspends in a row from a script should not be too bad.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

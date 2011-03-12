Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1CLRfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 12:35:45 -0500
Received: from www.tglx.de ([62.245.132.106]:57805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab1CLRfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 12:35:42 -0500
Date: Sat, 12 Mar 2011 18:35:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, johnstul@us.ibm.com
Subject: Re: [PATCH 3/3] Check for write permission on FD based
 posix-clocks
In-Reply-To: <20110312172349.GB3048@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1103121834400.2787@localhost6.localdomain6>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de> <1299173174-348-4-git-send-email-torbenh@gmx.de> <20110304072239.GA8957@riccoc20.at.omicron.at> <alpine.LFD.2.00.1103112044410.2787@localhost6.localdomain6>
 <20110312172349.GB3048@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Mar 2011, Richard Cochran wrote:

> On Fri, Mar 11, 2011 at 08:46:57PM +0100, Thomas Gleixner wrote:
> > As Arnd already said -EACCES is sensible for file permission checks
> > while -EPERM means that you have no permission at all.
> 
> Okay, so you will accept Torben's patch as is, into timers/core?

If there are no further objections, I'll pick it up.

Thanks,

	tglx

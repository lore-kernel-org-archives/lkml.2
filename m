Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab1EMJ2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:28:54 -0400
Received: from smtp.nokia.com ([147.243.128.26]:46591 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab1EMJ2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:28:53 -0400
Date: Fri, 13 May 2011 12:23:48 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sysfs: remove "last sysfs file:" line from the oops
	messages
Message-ID: <20110513092347.GA10696@esdhcp04044.research.nokia.com>
References: <20110512230102.GA19069@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512230102.GA19069@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/11 16:01 -0700, ext Greg KH wrote:
> ---------------
> I'm going to queue this up for the .40 kernel merge window, any
> objections?
> ---------------
> 
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> On some arches (x86, sh, arm, unicore, powerpc) the oops message would
> print out the last sysfs file accessed.
> 
> This was very useful in finding a number of sysfs and driver core bugs
> in the 2.5 and early 2.6 development days, but it has been a number of
> years since this file has actually helped in debugging anything that
> couldn't also be trivially determined from the stack traceback.
> 
> So it's time to delete the line.  This is good as we need all the space
> we can get for oops messages at times on consoles.
> 
> Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Worksforme.

Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Cheers,
Phil

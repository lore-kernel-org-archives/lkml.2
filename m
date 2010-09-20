Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab0ITS6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:58:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36723 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756819Ab0ITS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:58:50 -0400
Date: Mon, 20 Sep 2010 14:58:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Heinz Diehl <htd@fancy-poultry.org>
cc: Alan Ott <alan@signal11.us>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
In-Reply-To: <20100920181100.GA12295@fancy-poultry.org>
Message-ID: <Pine.LNX.4.44L0.1009201456260.2010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Heinz Diehl wrote:

> On 12.08.2010, Heinz Diehl wrote: 
> 
> > > >>Could please those of you, who are able to reproduce the problem, verify
> > > >>whether the patch below (completely untested) makes everything behave
> > > >>again? Thanks.
>  
> > > >Yes, everything behaves again. Thanks Jiri.
>   
> > > Seconded. Works good. Thanks for your support Jiri.
>  
> > Thirded! This fixes the warning here.
> 
> Unfortunately, I have to take up this problem a second time. 
> I considered the issue fixed, and in fact it was using Jiris patch.
> 
> However, the same problem came back while testing 2.6.36-rc4 and the
> following -git's. /var/log/warn shows the same warning as mentioned in
> the first mail in this thread:
> 
>  Sep 20 08:18:42 liesel apcupsd[5436]: apcupsd FATAL ERROR in linux-usb.c at line 609 
>  Cannot find UPS device -- For a link to detailed USB trouble
>  shooting information, please see <http://www.apcupsd.com/support.html>.
>  Sep 20 08:18:42 liesel apcupsd[5436]: apcupsd error shutdown completed
> 
> No additional oops this time, only the warning, and my UPS is no longer
> working.
> 
> Jiris patch obviously didn't made it into 2.6.36-rc4, and it doesn't
> apply nay longer either.

No, you're wrong.  The patch _is_ in 2.6.36-rc4, and that's the reason 
why it doesn't apply any longer.

The error you see must have a different cause.  Have you read this 
thread?

	http://marc.info/?t=128494644600005&r=1&w=2

Alan Stern


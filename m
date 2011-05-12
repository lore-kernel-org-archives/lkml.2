Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab1ELQzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:55:05 -0400
Received: from kroah.org ([198.145.64.141]:40952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758027Ab1ELQzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:55:02 -0400
Date: Thu, 12 May 2011 09:54:59 -0700
From: Greg KH <greg@kroah.com>
To: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v6] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20110512165459.GA14243@kroah.com>
References: <1305040232-750-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110510200801.GA8125@kroah.com>
 <AFCDDB4A3EA003429EEF1E7B211FDBBA3395A1A289@EXDCVYMBSTM005.EQ1STM.local>
 <20110511134859.GB12717@kroah.com>
 <AFCDDB4A3EA003429EEF1E7B211FDBBA3395A6DC72@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA3395A6DC72@EXDCVYMBSTM005.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 01:54:46PM +0200, Par-Gunnar HJALMDAHL wrote:
> Hi Greg,
> 
> I downloaded you staging tree and compared the logs for the core.h file.
> Compared to linux-next tag next-20110510 it is missing 2 commits:
> 4dbee6b76fffd5740e87e286f4f4c1c15901bcae
> 558aa9c0d620b91a896d5e39ce8a570bed65589b
> where the first one is the "oldest" one in the log and is the most
> important one for my patch.

What trees are these patches coming from?

> Another option would be for me to fix the patch for your tree, but
> then I would probably have to fix it back in a few days when you update
> your staging tree to Linux-next. How often is your tree updated?

linux-next pulls from my tree, I don't pull from linux-next.

As I don't see those patches in Linus's tree, I can't merge my tree
forward to include them yet.  I could take those patches also through my
tree if you want me to, or you could send this patch through the mfd
tree so that things build properly there too.

> The easiest is probably to wait a few days until you have the next-20110510
> tag in your tree and then apply the patch.

That will never happen, see above for how linux-next works.

thanks,

greg k-h

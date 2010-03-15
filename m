Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936824Ab0COVGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:06:00 -0400
Received: from kroah.org ([198.145.64.141]:37489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936790Ab0COVFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:05:55 -0400
Date: Mon, 15 Mar 2010 13:33:49 -0700
From: Greg KH <greg@kroah.com>
To: Ari Entlich <atrigent@ccs.neu.edu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/36] tty: Add a new VT mode which is like VT_PROCESS
 but doesn't require a VT_RELDISP ioctl call
Message-ID: <20100315203349.GC6757@kroah.com>
References: <9842632.318001267575211703.JavaMail.root@zimbra>
 <11363741.318021267575368900.JavaMail.root@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11363741.318021267575368900.JavaMail.root@zimbra>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 07:16:08PM -0500, Ari Entlich wrote:
> ----- "Greg KH" <gregkh@suse.de> wrote:
> > Hm, it's been there for over a week from what I can tell, right?
> 
> Hmm yes, I suppose it has.
> 
> > I'll revert it after this batch goes into Linus's tree.  Next time, warn
> > me a bit earlier :)
> 
> I apologize; I would have if I had realized that you picking it up meant it
> was on its way to mainline.

So, are you happy with this in Linus's tree, or do you want it reverted?

thanks,
greg k-h

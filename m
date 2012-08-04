Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab2HDErH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:47:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58059 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2HDErC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:47:02 -0400
Date: Sat, 4 Aug 2012 05:46:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dedekind1@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6-rc1
Message-ID: <20120804044659.GI23464@ZenIV.linux.org.uk>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
 <1343976472.1730.18.camel@sauron.fi.intel.com>
 <CA+55aFz322dKXUwtmrrW=nfp5XJa5ACh1syE8RXOOdcA7V_76A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz322dKXUwtmrrW=nfp5XJa5ACh1syE8RXOOdcA7V_76A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 01:23:29PM -0700, Linus Torvalds wrote:
> On Thu, Aug 2, 2012 at 11:47 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> >
> > We have had 11 of 13 pieces of the 'sync_supers()' removal patch-sets
> > merged. The 12th piece removes dead code in exofs was supposed to go
> > through the exofs tree and blocked the 13th piece which removes
> > 'sync_supers()' and was supposed to go via the VFS tree.
> >
> > Both 12th and 13th pieces zap dead code. I man not sure delaying that to
> > v3.7 would be very beneficial for the kernel (why having a useless
> > thread waking up every 5 secs?). Would you let us merge this to -rc1?
> 
> Ok. I'm pulling the exofs changes, they're small and remove more lines
> than they add. And if the last piece then just kills dead code, I
> won't mind that either.

OK...  I've ported Artem's patchset on top of exofs merge; Artem, could
you check if you are OK with the result currently in vfs.git#for-linus?

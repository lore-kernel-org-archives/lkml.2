Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab0EAAeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:34:17 -0400
Received: from ozlabs.org ([203.10.76.45]:35786 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612Ab0EAAeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:34:15 -0400
Date: Sat, 1 May 2010 10:34:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
Message-ID: <20100501003410.GB2610@brick.ozlabs.ibm.com>
References: <4BD80037.9060704@kernel.org>
 <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz>
 <20100430075510.GA21105@elte.hu>
 <alpine.LNX.2.00.1004300957130.9849@pobox.suse.cz>
 <20100430083720.GA3318@elte.hu>
 <alpine.LNX.2.00.1004301103280.9849@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004301103280.9849@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 11:04:46AM +0200, Jiri Kosina wrote:
> On Fri, 30 Apr 2010, Ingo Molnar wrote:
> 
> > > Well, Paul himself stated that according to their lawyer department, 
> > > "Copyright" (which is there) is enough. So it made sense to remove invalid 
> > > (at least in some sense) character.
> > > 
> > > Also zillion of other files copyrighted by Paul contain "Copyright (C)".
> > > 
> > > If we really want this character there then, why not rather in UTF-8, so 
> > > that it works flawlessly?
> > 
> > It might be fine but i havent seen Paul reply to this thread - and this is my 
> > point: _you_ should have waited for an ack from Paul (who is co-maintaining 
> > that file) before applying it. The commit doesnt have it:
> 
> I got Pauls reply as "as soon as there is `Copyright', it's fine". If I 
> misunderstood it, sorry for that, and I'll drop the patch.
> 
> Paul, could you please send explicit Acked-by: or Naked-by:, so that 
> everything is in line?

Nacked-by: Paul Mackerras <paulus@samba.org>

Please apply the patch I just sent that changes the encoding to
UTF-8.

I take your point that there are lots of other copyright notices in
the kernel with "(C)", including mine, and I'm not for a moment
suggesting that they are all invalid.  Nevertheless, it seems that it
is better to use the proper copyright symbol rather than "(C)" for new
code, so I'd like to keep the copyright symbol here.

Paul.

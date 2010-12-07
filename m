Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0LGPib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:38:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab0LGPi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:38:29 -0500
Date: Tue, 7 Dec 2010 10:37:58 -0500
From: Don Zickus <dzickus@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-ID: <20101207153758.GJ21786@redhat.com>
References: <20101122133949.93201b15.sfr@canb.auug.org.au>
 <20101129135023.4a931f86.sfr@canb.auug.org.au>
 <20101129082916.GA12374@elte.hu>
 <20101129143047.GM18100@redhat.com>
 <20101207125822.1d43e572.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207125822.1d43e572.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 12:58:22PM +1100, Stephen Rothwell wrote:
> > > Don, have you got a fix for that?
> > 
> > I do.  I posted it last week, but you wanted me to post something
> > incremental instead.  I'll get that out today.
> 
> I am still reverting those 2 commits.

I posted the patch to fix it last week, not sure if Ingo needs something
else from me.

http://thread.gmane.org/gmane.linux.kernel/1069682/focus=1069960

Cheers,
Don

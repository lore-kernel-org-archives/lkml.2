Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab0FVXWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:22:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63760 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0FVXWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qRb5fZdWaE41rkQ7Z9SHeomquCVFezytquqgkWu8LNXfXAw89utzOHc0OF6eZVfLNR
         9L2SW8EJxNgfPoNxX9+J+eBfkwHK5Ql41KlYnDiJOCS3uqDwGn1d5ThSKgWxILSPOM0f
         jaZNAX6n24qZwzw9osXTymYCAwxo3hlXmwB6U=
Date: Tue, 22 Jun 2010 16:22:38 -0700
From: mark gross <640e9920@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: markgross@thegnar.org, 640e9920@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100622232238.GA15442@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100621055522.GE9735@gvim.org>
 <Pine.LNX.4.44L0.1006211125470.1687-100000@iolanthe.rowland.org>
 <20100622015837.GC12795@gvim.org>
 <20100622081803.4d472542@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622081803.4d472542@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 08:18:03AM +0200, Florian Mickler wrote:
> On Mon, 21 Jun 2010 18:58:37 -0700
> mark gross <640e9920@gmail.com> wrote:
> 
> 
> > wrong.  They are about 1) adding opportunistic suspend, and 2) adding
> > critical sections to block suspend.  
> > 
> > No race issues where ever talked about until alternative solutions
> > where put up.
> 
> The whole and only reason to even define the term "critical sections" is
> when you need to define "a race". Or vice versa. A race is prevented by
> defining critical sections and protecting these against concurrent
> access.
> 
> [..snip..]
> 
> [some rant that alan is not familiar with android userspace..]
> 
> Are you suggesting that only android developers are supposed to talk
> about this? 

of course not.  I'm just getting frustrated with having android-isms
tossed in my face as we try to discuss the merits of the ideas, only to
find that the are getting tossed around by someone not familiar with
Android.

Sorry about that.  I was having a bad day.

--mgross




> 
> This is a pretty basic thing. It has only to do with system suspend.
> (And using system suspend aggressively)
> 
> > 
> > --mgross
> > 
> 
> Cheers,
> Flo

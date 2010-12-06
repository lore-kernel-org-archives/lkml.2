Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0LFOuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:50:03 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:56767 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0LFOuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=DidslkehAeRGmozBI1tYjHB77tSaL5GhpFMa2ZmwWSRx0WGteTQzAdLtE1mcii+NEr
         NI7RgpD5e4DEPWHIG3HbBImJdsitQBCqKaqWDtDKLnbgrSwrNnlwF/1S5P23WOXHucIL
         j871s6GdjAA3vr2ihyAF67WzmslqlEG0F96js=
Date: Mon, 6 Dec 2010 12:49:55 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] perf: Prevent potential null dereference
Message-ID: <20101206144954.GA25943@ghostprotocols.net>
References: <20101202222605.GA6471@lenovo>
 <20101202224104.GA1639@nowhere>
 <20101202224609.GA31473@ghostprotocols.net>
 <20101205221321.GD7799@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101205221321.GD7799@lenovo>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 06, 2010 at 01:13:21AM +0300, Cyrill Gorcunov escreveu:
> On Thu, Dec 02, 2010 at 08:46:10PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Dec 02, 2010 at 11:41:08PM +0100, Frederic Weisbecker escreveu:
> > > On Fri, Dec 03, 2010 at 01:26:05AM +0300, Cyrill Gorcunov wrote:
> > > > In case if there is no memory we might hit null
> > > > dereference on accessing calloc'ed data.
> > > > 
> > > > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > > > CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > > CC: Peter Zijlstra <peterz@infradead.org>
> > > > CC: Ingo Molnar <mingo@elte.hu>
> > > > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > > > ---
> ...
> > > 
> > > Good.
> > > 
> > > As a nit, not that it matters that much because we are very close to the starting code
> > > anyway, but it would be better to propagate the error to the callers.
> > 
> > I'm of the opinion that main() should be where exit() is allowed, and
> > even there... return would be better. 8-)
> > 
> > - Arnaldo
> > 
> 
> ok, sorry for delay, it seems the following would be liked
> more than first version ;)
> 

Hey, what tree is this agains? I guess tip/master, right? If so, I still
didn't got there :-\

- Arnaldo

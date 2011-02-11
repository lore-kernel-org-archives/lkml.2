Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1BKV0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:26:08 -0500
Received: from kroah.org ([198.145.64.141]:51107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab1BKV0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:26:06 -0500
Date: Fri, 11 Feb 2011 13:25:54 -0800
From: Greg KH <greg@kroah.com>
To: Florian Mickler <florian@mickler.org>
Cc: Harry Wei <jiaweiwei.xiyou@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, rdunlap@xenotime.net,
        trivial@kernel.org
Subject: Re: MAINTAINERS: a question about it
Message-ID: <20110211212554.GA11175@kroah.com>
References: <20110211122924.GA2088@gmail.com>
 <20110211154014.GA13716@kroah.com>
 <20110211221433.5f92368c@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211221433.5f92368c@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:14:33PM +0100, Florian Mickler wrote:
> On Fri, 11 Feb 2011 07:40:14 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Feb 11, 2011 at 08:29:28PM +0800, Harry Wei wrote:
> > > Hi us,
> > >      I saw MAINTAINERS these days. I find we should program a script(shell) for checking if a maintainer added himself in correct position. 
> > >      Because the MAINTAINERS is in alphabetical order and it has lots of maintainers now.
> > >      I just want to ask if anyone is doing this work. If it has  been began i will do other things about kernel. If not, i will program this script(shell) for us.
> > 
> > Why not just modify the 'scripts/get_maintainers.pl' tool to do this?
> > 
> > thanks,
> > 
> > greg k-h
> 
> surely, you mean hooking it into 'scripts/checkpatch.pl' ?
> 

No, I hadn't ment that, as I figured get_maintainers.pl already parsed
the MAINTAINERS file, so it might be easier to do it there.

But you are probably right, it's only an issue when you add a
MAINTAINERS entry, so it should go into that script.

Although I'm really loath to add any more to that script, it's slow
enough as it is on large patches :(

thanks,

greg k-h

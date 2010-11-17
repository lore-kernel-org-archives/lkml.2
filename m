Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab0KQDnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:43:33 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43660 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0KQDnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:43:32 -0500
Date: Wed, 17 Nov 2010 12:28:01 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        stable@kernel.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] Make swap accounting default behavior configurable
Message-Id: <20101117122801.e9850acf.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20101116171225.274019cf.akpm@linux-foundation.org>
References: <20101116101726.GA21296@tiehlicka.suse.cz>
	<20101116124615.978ed940.akpm@linux-foundation.org>
	<20101117092339.1b7c2d6d.nishimura@mxp.nes.nec.co.jp>
	<20101116171225.274019cf.akpm@linux-foundation.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 17:12:25 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 17 Nov 2010 09:23:39 +0900 Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > > > 
> > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > index ed45e98..14eafa5 100644
> > > > --- a/Documentation/kernel-parameters.txt
> > > > +++ b/Documentation/kernel-parameters.txt
> > > > @@ -2385,6 +2385,9 @@ and is between 256 and 4096 characters. It is defined in the file
> > > >  			improve throughput, but will also increase the
> > > >  			amount of memory reserved for use by the client.
> > > >  
> > > > +	swapaccount	[KNL] Enable accounting of swap in memory resource
> > > > +			controller. (See Documentation/cgroups/memory.txt)
> > > 
> > > So we have swapaccount and noswapaccount.  Ho hum, "swapaccount=[1|0]"
> > > would have been better.
> > > 
> > I suggested to keep "noswapaccount" for compatibility.
> > If you and other guys don't like having two parameters, I don't stick to
> > the old parameter.
> > 
> 
> Yes, we're stuck with the old one now.
> 
> But we should note that "foo=[0|1]" is superior to "foo" and "nofoo". 
> Even if we didn't initially intend to add "nofoo".
> 
I see.

Michal-san, could you update your patch to use "swapaccount=[1|0]" ?

Thanks,
Daisuke Nishimura.

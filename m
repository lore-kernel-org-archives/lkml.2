Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0KRKQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:16:40 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39553 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab0KRKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:16:38 -0500
Date: Thu, 18 Nov 2010 19:14:27 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        stable@kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] Make swap accounting default behavior configurable v4
Message-Id: <20101118191427.fd86db5c.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20101118095607.GD15928@tiehlicka.suse.cz>
References: <20101116101726.GA21296@tiehlicka.suse.cz>
	<20101116124615.978ed940.akpm@linux-foundation.org>
	<20101117092339.1b7c2d6d.nishimura@mxp.nes.nec.co.jp>
	<20101116171225.274019cf.akpm@linux-foundation.org>
	<20101117122801.e9850acf.nishimura@mxp.nes.nec.co.jp>
	<20101118082332.GB15928@tiehlicka.suse.cz>
	<20101118174654.8fa69aca.nishimura@mxp.nes.nec.co.jp>
	<20101118175334.be00c8f2.kamezawa.hiroyu@jp.fujitsu.com>
	<20101118095607.GD15928@tiehlicka.suse.cz>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 10:56:07 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 18-11-10 17:53:34, KAMEZAWA Hiroyuki wrote:
> > On Thu, 18 Nov 2010 17:46:54 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > On Thu, 18 Nov 2010 09:23:32 +0100
> > > Michal Hocko <mhocko@suse.cz> wrote:
> > > 
> > > > On Wed 17-11-10 12:28:01, Daisuke Nishimura wrote:
> > > > > On Tue, 16 Nov 2010 17:12:25 -0800
> > > > > Andrew Morton <akpm@linux-foundation.org> wrote:
> [...]
> > > > > > Yes, we're stuck with the old one now.
> > > > > > 
> > > > > > But we should note that "foo=[0|1]" is superior to "foo" and "nofoo". 
> > > > > > Even if we didn't initially intend to add "nofoo".
> > > > > > 
> > > > > I see.
> > > > > 
> > > > > Michal-san, could you update your patch to use "swapaccount=[1|0]" ?
> > > > 
> > > > I have noticed that Andrew has already taken the last version of the
> > > > patch for -mm tree. Should I still rework it to change swapaccount to
> > > > swapaccount=0|1 resp. true|false?
> > > > 
> > > It's usual to update a patch into more sophisticated one while it is in -mm tree.
> > > So, I think you'd better to do it(btw, I prefer 0|1 to true|false.
> > > Reading kernel-parameters.txt, 0|1 is more commonly used.).
> > > 
> > 
> > I vote for 0|1
> 
> Changes since v3:
> * add 0|1 parameter values handling
> 
> Changes since v2:
> * put the new parameter description to the proper (alphabetically
> * sorted)
>   place in Documentation/kernel-parameters.txt
>   
> Changes since v1:
> * do not remove noswapaccount parameter and add swapaccount parameter
> * instead
> * Documentation/kernel-parameters.txt updated)
> 

I'm sorry again and again, but I think removing "noswapaccount" completely
would be better, as Andrew said first:
> So we have swapaccount and noswapaccount.  Ho hum, "swapaccount=[1|0]"
> would have been better.


Thanks,
Daisuke Nishimura.

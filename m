Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0ICEq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 00:46:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63071 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0ICEq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 00:46:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oEWQLpbRYTZKvfAbM4tUwEd1Wm/TzJD0B0DnkCR8OgVrSKw9A2Ld+letf50N35agBk
         OrH+iEpzFaPHVk8HuoMPbuI0YDnpLC7IvR6XO8jj+hNFueBQLBLKtfDddG3eidg2NoGl
         DHuHuuxhWfjA4vFco5N205iWgpUP/d1gxrqvw=
Date: Fri, 3 Sep 2010 06:46:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        laijs@cn.fujitsu.com, scott.a.mcmillan@intel.com,
        eric.dumazet@gmail.com, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH v4 0/5] netdev: show a process of packets
Message-ID: <20100903044656.GA6589@nowhere>
References: <4C72422C.5070102@jp.fujitsu.com> <1283212210.3656.84.camel@gandalf.stny.rr.com> <4C80592B.2060406@jp.fujitsu.com> <20100902.191741.233696520.davem@davemloft.net> <4C806388.9020509@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C806388.9020509@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 11:55:04AM +0900, Koki Sanagi wrote:
> (2010/09/03 11:17), David Miller wrote:
> > From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> > Date: Fri, 03 Sep 2010 11:10:51 +0900
> > 
> >> Thanks many acks. and I have one question.
> >>
> >> These patches have several component.
> >>
> >> Patch1 is kernel component, but patch2-5 are netdev component.
> >> What tree is good to be included ?
> >> If it is not net-next, I must rebase to another tree.
> > 
> > I would prefer it goes into the tracing tree or whatever is the most appropriate
> > for patch #1.
> > 
> 
> O.K. I'll rebase to linux-2.6-tip.


No need, they apply very well :)

I'll push that to -tip soon.

Thanks.


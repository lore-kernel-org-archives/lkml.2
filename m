Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab0FUPfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:35:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:56803 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab0FUPfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IKXeQMam21LAmuYeKSsKGc79gJHQHLmbSoBA9nYa3e1UKdNpWIo65JR78MeKpqP62O
         5IUXOw3Q8OfQzec8Ts2xZm3fyZhbjLSrVOj41o4KtU5s3Oc42oxCi8ZxNKuwfEla0gFi
         eibQ/fFDhaeB9w7i3KqlOdZeGu/w5QyNCKGPo=
Date: Mon, 21 Jun 2010 17:33:03 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Carpenter <error27@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H.PeterA" <nvinhpa@zytor.com>, Venkatesh Pallipadi <venki@google.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
Message-ID: <20100621153303.GA2754@joi.lan>
References: <20100617134559.GA29824@bicker>
 <20100617161728.GA2741@joi.lan>
 <4C1B1691.6020809@redhat.com>
 <20100618175726.GA2785@joi.lan>
 <4C1F455E.6050502@redhat.com>
 <1277118155.1875.508.camel@laptop>
 <4C1F47EF.2060509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F47EF.2060509@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 07:07:27PM +0800, Xiaotian Feng wrote:
> On 06/21/2010 07:02 PM, Peter Zijlstra wrote:
> > On Mon, 2010-06-21 at 18:56 +0800, Xiaotian Feng wrote:
> >
> >> I guess there might be something wrong between the augmented rbtree insert/remove ..
> >
> > The easiest thing is to revert that change and try again, the next step
> > would be to print the full RB tree on each modification and look where
> > it goes wrong.
> >
> > That said, I did print my fair share of (augmented) RB trees while
> > playing with scheduler patches and I can't remember it ever having
> > messed up like that.
> He's using 2.6.35-rc2+, without your "rbtree: Undo augmented trees 
> performance damage" patch ;-)

I applied it manually (commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249 from -tip)
to 2.6.35-rc3 and it fixed both acpi's and nouveau's "invalid memtype" messages.
Thanks.

Marcin

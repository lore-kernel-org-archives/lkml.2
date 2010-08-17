Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0HQP2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:28:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab0HQP2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:28:30 -0400
Subject: Re: [GIT PULL] notification tree - try 37!
From: Eric Paris <eparis@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Andreas Gruenbacher <agruen@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <201008171155.21479.tvrtko.ursulin@sophos.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <201008171201.10142.agruen@suse.de>
	 <201008171112.42097.tvrtko.ursulin@sophos.com>
	 <201008171155.21479.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:27:49 -0400
Message-ID: <1282058869.21419.134.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 11:55 +0100, Tvrtko Ursulin wrote:
> On Tuesday 17 Aug 2010 11:12:41 Tvrtko Ursulin wrote:
> > On Tuesday 17 Aug 2010 11:01:09 Andreas Gruenbacher wrote:
> > > I'm quite sure that both of these issues have been discussed already.
> >
> > Ok, I obviosuly missed it. Do you have a pointer perhaps?
> 
> I have found the thread. It has been discussed but I do not find it had a
> clear outcome. At the end Eric has proposed the heartbeat/in-progress option
> (which IMHO can only work together with a timeout) to which no-one objected. I
> did not find other arguments against such functionality solid.

You'll notice that anything anyone I respected objected to, even if I
didn't agree, I dropped or replaced.  I had such code.  We can bring it
back.  But the objection was: 'what's the point?"  They believed that
everyone would just do it in a library and end up in the 'block forever'
situation we have today.

-Eric


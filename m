Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2KZXgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:36:53 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:54440 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337Ab2KZXgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:36:53 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, George Zhang <georgezhang@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 00/12] VMCI for Linux upstreaming
Date: Mon, 26 Nov 2012 15:36:52 -0800
Message-ID: <4072068.8FbmJn8R3Z@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121126232357.GA21664@kroah.com>
References: <20121121202625.13252.86346.stgit@promb-2n-dhcp175.eng.vmware.com> <1975718.7UL0qBEfzR@dtor-d630.eng.vmware.com> <20121126232357.GA21664@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 03:23:57 PM Greg KH wrote:
> On Mon, Nov 26, 2012 at 03:01:04PM -0800, Dmitry Torokhov wrote:
> > On Monday, November 26, 2012 02:37:54 PM Greg KH wrote:
> > > On Wed, Nov 21, 2012 at 12:31:04PM -0800, George Zhang wrote:
> > > > * * *
> > > > This series of VMCI linux upstreaming patches include latest udpate
> > > > from
> > > > VMware.
> > > > 
> > > > Summary of changes:
> > > > 	- Sparse clean.
> > > > 	- Checkpatch clean with one exception, a "complex macro" in
> > > > 	
> > > > 	  which we can't add parentheses.
> > > > 	
> > > > 	- Remove all runtime assertions.
> > > > 	- Fix device name, so that existing user clients work.
> > > > 	- Fix VMCI handle lookup.
> > > 
> > > Given that you failed to answer the questions I asked the last time you
> > > posted this series, and you did not make any of the changes I asked for,
> > > I can't accept this (nor should you expect me to.)
> > > 
> > > And people wonder why reviewers get so grumpy...
> > > 
> > > My trees are now closed for the 3.8 merge window, so feel free to try
> > > again after 3.8-rc1 is out, and you have answered, and addressed, the
> > > questions and comments I made.
> > 
> > Greg, there were 3 specific complaints from you:
> > 
> > 1. "Given that this is a static function, there's no need for these
> > "asserts", right?  Please send a follow-on patch removing all BUG_ON()
> > calls from these files, it's not acceptable to crash a user's box from
> > a driver that is handling parameters you are feeding it."
> > 
> > 2. "You obviously didn't run checkpatch on this file"
> > 
> > 3. "This line causes sparse to complain.  The odds that userspace knows
> > what gcc is using for "bool" is pretty low."
> > 
> > Given the fact that the series addresses all 3 I fail to understand why
> > you would be grumpy.
> 
> You are ignoring my response to patch 12/12 for some reason (which
> repeated a bunch of the questions I had with that patch the last time it
> was posted.)  That is what I am referring to here.  None of those
> questions were addressed.

That one was explicitly acknowledged in
<20121030052234.GH32055@dtor-ws.eng.vmware.com> and fixed in series
posted on 11/01. Since it was fixed in earlier posting we did not
mention it again.

> 
> Also, how was I to know that those 3 comments above were addressed?
> When someone posts questions and comments, please respond to those
> comments.  Don't just not respond at all and post the whole series 2
> weeks later with things changed and a vague comment of "summary of
> changes" in the 00 message.  Otherwise I will assume that you never even
> saw my post.

I thought "Sparse clean" and "Checkpatch clean with one exception ..."
are concrete enough, but I am open to improving the messaging. What 
would you like us to say?

> 
> In other words, if someone takes the time to review and post comments,
> the least you can do is acknowledge those comments, right?

We did not want to litter mailing lists with "OK" responses, but will
do in the future.

Thanks,
Dmitry

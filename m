Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0EFTUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:20:07 -0400
Received: from kroah.org ([198.145.64.141]:54593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab0EFTUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:20:04 -0400
Date: Thu, 6 May 2010 12:18:16 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Vadim Rozenfeld <vrozenfe@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH] x86: detect running on a HyperV system
Message-ID: <20100506191816.GA20874@kroah.com>
References: <20100506190841.GA1605@kroah.com>
 <4BE314CD.6060701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE314CD.6060701@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 12:13:17PM -0700, H. Peter Anvin wrote:
> On 05/06/2010 12:08 PM, Greg KH wrote:
> > 
> > x86-maintainers, we need this patch in the tree to get a -staging driver
> > to work properly.  If you don't object, can I take it through the
> > staging tree?  Or do you want to take it in -tip?
> > 
> 
> I'd prefer to take it in -tip, partly because I would like to rework a
> few things -- including preexisting braindamage like c->x86_hyper_vendor
> (since when was hypervisor vendor a per-cpu property!?)

Heh, good point, but where should it live?

And I have no objection to taking it in -tip, thanks for doing so.

> I'll try to get to it today, if not feel free to bug me.

Will do :)

thanks again,

greg k-h

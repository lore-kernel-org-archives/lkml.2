Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451Ab2HWVH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:07:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934412Ab2HWVHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:07:25 -0400
Date: Tue, 27 Jan 2009 16:53:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: hch@infradead.org, corbet@lwn.net, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
        linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-Id: <20090127165359.d6b95b52.akpm@linux-foundation.org>
In-Reply-To: <20090123045646.GK15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122203248.GA20159@infradead.org>
	<20090123045646.GK15750@one.firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009 05:56:46 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Jan 22, 2009 at 03:32:49PM -0500, Christoph Hellwig wrote:
> > On Thu, Jan 22, 2009 at 06:51:04AM -0800, Andrew Morton wrote:
> > > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > > straightforwad.  But it's really really sad.  It basically leaves a great
> > > big FIXME in there.  It'd be better to fix it.
> > 
> > 
> > Umm, we've been discussiong this in and out a guestimated million times.
> > 
> > Let's go forward with Jon's patch which is on obvious improvement and
> > if it shows problems later on we can revisit it.
> 
> The point was that we already have a better patch from Oleg.
> 

Where is this patch??

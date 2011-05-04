Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1EDWJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:09:30 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56798 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1EDWJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DQS19MOnc4/SkzeDy1Immb0YYNYpTVTs8RIHnPySaL+A6wWe1CpHUtRJVtZs90dAD1
         cv1uQ+yprR6Lyk0rz098RmJHEvFbUpp639wvkS93MYmAsWWBCZC2awWUqW2Ej/EAbPtO
         8gg43XDG1BviOZkEqxtZJSAeLXx7rSZ8nL3nM=
Date: Thu, 5 May 2011 00:09:22 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Mike Frysinger <vapier@gentoo.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Message-ID: <20110504220922.GA4811@linux.develer.com>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
 <20110504144411.7f32c00c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504144411.7f32c00c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 02:44:11PM -0700, Andrew Morton wrote:
> On Wed, 27 Apr 2011 20:13:47 +0200
> Andrea Righi <andrea@betterlinux.com> wrote:
> 
> > Introduce a new fadvise flag to drop page cache pages of a single
> > filesystem.
> 
> I'm going to object to this on general principle.  We shouldn't toss
> new features into the kernel API just because we can.  Each feature
> needs a really good argument to justify its inclusion, and I don't
> believe that the case has been made for this feature.
> 
> IOW, who's going to die if we don't merge it?

OK. :)

-Andrea

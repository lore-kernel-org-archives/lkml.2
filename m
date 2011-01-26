Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1AZBBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 20:01:51 -0500
Received: from smtp-out.google.com ([74.125.121.67]:29510 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1AZBBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 20:01:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=nuDmlWYr+gCkCco/KoiJSC9XNyXopNSUm8d4VvcljAwb2UkeC/Uxum+iOv1IBKx75p
         4JDCvuOHsiiNq8FezJiw==
Date: Tue, 25 Jan 2011 17:01:37 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Message-ID: <20110126010137.GS8008@google.com>
References: <20110125235700.GR8008@google.com>
 <1296002449.6115.9.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296002449.6115.9.camel@Joe-Laptop>
X-Operating-System: Linux/2.6.32-gg298-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (joe@perches.com) wrote:
> On Tue, 2011-01-25 at 15:57 -0800, Mandeep Singh Baines wrote:
> > To make it easier to audit dmesg, we'd like to make
> > DEFAULT_MESSAGE_LEVEL Kconfig-settable. That way we can set it to
> > KERN_NOTICE and audit any messages <= KERN_WARNING.
> 
> Seems sensible, but mightn't it be better to make sure
> that all printks use a specific KERN_<level> rather
> than check that printks without a KERN_<level> are
> emitted at a selectable level?
> 

Can we do both? I was planning sending cleanup patches as well but expected
that process to take a while. The simplest thing would to set all these
to KERN_WARNING but that's not correct and leaves me back where I started.
The correct thing would be to set each printk to an appropriate level.
Determining appropriate level will take some discussion (so a long term
project).

> 

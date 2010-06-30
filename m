Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab0F3HNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:13:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55152 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0F3HNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nG/2YS4RWPykX2sTMkP4nYAAwIVLSXzudGAkIwRq90om5fN3Lfu2ZiHmoEXj3BaKQw
         WejXNaexMLETT6cQPrPj6cNG4NVhgNT2vCFirKwwKHjCsblK8LNlTbQE6HxHBKQ9XIpU
         uD6ExSZTythGSY2WHuyrKRk6ST30HPBJBUsb0=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 02/52] fs: fix superblock iteration race
Date: Wed, 30 Jun 2010 08:13:31 +0100
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Al Viro <viro@zeniv.linux.org.uk>
References: <20100624030212.676457061@suse.de> <20100629201409.GO28364@laptop> <201006292138.40293.chris2553@googlemail.com>
In-Reply-To: <201006292138.40293.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006300813.31762.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 June 2010, Chris Clayton wrote:
> On Tuesday 29 June 2010, Nick Piggin wrote:
> > On Tue, Jun 29, 2010 at 09:04:33PM +0100, Chris Clayton wrote:

> > >
> > > I'll spend a couple of hours doing stuff and see if I can generate an
> > > oops. Trouble is, of course, that when I pull and build the latest and
> > > greatest, I won't know why I'm not getting oopses, assuming I don't.
> >
> > Don't worry too much if you can't reproduce. I'd say it is likely to be
> > this bug, and if so, it is going to depend significantly on timing and
> > ordering of mounts/umounts.
>
> Yes, that makes sense. I did quite a bit of copying files to and from USB
> storage devices this morning. I've got some more to do, so I'll see what
> that produces.

Well, try as I may, these oopses are like London buses - firstly you get three 
in quick succession when you don't need them and then when you do, none turn 
up. Oh well!

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller

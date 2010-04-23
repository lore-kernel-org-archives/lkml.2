Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0DWBAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:00:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520Ab0DWBAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:00:49 -0400
Date: Thu, 22 Apr 2010 17:58:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       NeilBrown <neilb@suse.de>, akpm@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [166/197] md/raid5: allow for more than 2^31
 chunks.
In-Reply-To: <20100422203338.617debf9@redhat.com>
Message-ID: <alpine.LFD.2.00.1004221758270.26046@i5.linux-foundation.org>
References: <20100422191857.GA13268@kroah.com> <20100422190922.238365037@kvm.kroah.org> <20100422203338.617debf9@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Apr 2010, Chuck Ebbert wrote:

> On Thu, 22 Apr 2010 12:10:17 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > 2.6.32-stable review patch.  If anyone has any objections, please let
> > us know.
> > 
> > ------------------
> > 
> > From: NeilBrown <neilb@suse.de>
> > 
> > commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> > 
> > With many large drives and small chunk sizes it is possible
> > to create a RAID5 with more than 2^31 chunks.  Make sure this
> > works.
> 
> Causes build failure on i686:
> ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!
> 
> http://lkml.org/lkml/2010/4/22/50

Yeah, that one is definitely not stable material as-is.

		Linus

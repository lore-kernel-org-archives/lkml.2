Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1FIQJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:09:46 -0400
Received: from mail.perches.com ([173.55.12.10]:2662 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1FIQJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:09:45 -0400
Subject: Re: [TRIVIAL PATCH v2] treewide: Convert uses of struct resource
 to resource_size(ptr)
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
In-Reply-To: <alpine.LNX.2.00.1106091423400.22872@pobox.suse.cz>
References: <201106061349.00474.hartleys@visionengravers.com>
	 <1307397174.4994.26.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
	 <1307408678.4994.46.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7EB4@AUSP01VMBX24.collaborationhost.net>
	 <1307482186.22272.29.camel@Joe-Laptop>
	 <alpine.LNX.2.00.1106091423400.22872@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 09:09:44 -0700
Message-ID: <1307635784.13329.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 14:25 +0200, Jiri Kosina wrote:
> On Tue, 7 Jun 2011, Joe Perches wrote:
> > Several fixes as well where the +1 was missing.
> > Done via coccinelle scripts like:
> > @@
> > struct resource *ptr;
> > @@
> > - ptr->end - ptr->start + 1
> > + resource_size(ptr)
> > and some grep and typing.
> > Mostly uncompiled, no cross-compilers.
> > Some checkpatch complaints cheerfully ignored.
> > Signed-off-by: Joe Perches <joe@perches.com>
> thanks a lot for the patch. I will be happily taking it. However it seems 
> like some of the files are going away/have been moved in -next. Could you 
> please respin on top of what is still applicable on -next and resend? 

Hi Jiri.

The original patch is for next-20110607.
There were 2 identical patches for resource_size
applied to the next tree as of next-20110609.

I just cherry-pick'ed it and the diff is the same
modulo those 2 already applied bits.

Because it's pretty large, I'll send the new diff
just to you off-list.

cheers, Joe


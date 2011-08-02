Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1HBWzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:55:52 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40815 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab1HBWzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:55:46 -0400
X-Sasl-enc: EZEg+HgTqwFy3xmM6jHeGTPSjo3aIC/HXPEFz00QTJo0 1312325745
Date: Tue, 2 Aug 2011 15:54:36 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Fix clashes with DRM updates
Message-ID: <20110802225436.GA30217@kroah.com>
References: <20110726161536.4910.21396.stgit@localhost.localdomain>
 <4E38601F.5090808@zytor.com>
 <20110802204803.GA14460@kroah.com>
 <4E38651C.1030008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E38651C.1030008@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 01:59:08PM -0700, H. Peter Anvin wrote:
> On 08/02/2011 01:48 PM, Greg KH wrote:
> > On Tue, Aug 02, 2011 at 01:37:51PM -0700, H. Peter Anvin wrote:
> >> On 07/26/2011 09:15 AM, Alan Cox wrote:
> >>> From: Alan Cox <alan@linux.intel.com>
> >>>
> >>> The private object support has migrated from gma500 into the DRM core,
> >>> remove our now clashing copy so -next can build.
> >>>
> >>> Signed-off-by: Alan Cox <alan@linux.intel.com>
> >>
> >> This patch is needed in Linus' tree, as it is currently causing a build
> >> failure for either i386 or x86_64 allyesconfig.
> > 
> > Ick, it is?  I don't see that here on my builds, what am I doing wrong?
> > 
> > confused,
> > 
> 
> No idea, but do a "make allyesconfig" on Linus' tree and you'll see it.

Ah, it's a link error, now I see it.  I'll queue it up, and some other
staging tree fixes and get them to Linus very soon now.

thanks,

greg k-h

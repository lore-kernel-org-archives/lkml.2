Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1HBUsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:48:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57110 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755223Ab1HBUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:48:09 -0400
X-Sasl-enc: 5C0VDyrEMOLHynLzTAwxpr2v+pckEVCNuAyqnhyeoWze 1312318088
Date: Tue, 2 Aug 2011 13:48:03 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Fix clashes with DRM updates
Message-ID: <20110802204803.GA14460@kroah.com>
References: <20110726161536.4910.21396.stgit@localhost.localdomain>
 <4E38601F.5090808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E38601F.5090808@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 01:37:51PM -0700, H. Peter Anvin wrote:
> On 07/26/2011 09:15 AM, Alan Cox wrote:
> > From: Alan Cox <alan@linux.intel.com>
> > 
> > The private object support has migrated from gma500 into the DRM core,
> > remove our now clashing copy so -next can build.
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> This patch is needed in Linus' tree, as it is currently causing a build
> failure for either i386 or x86_64 allyesconfig.

Ick, it is?  I don't see that here on my builds, what am I doing wrong?

confused,

greg k-h

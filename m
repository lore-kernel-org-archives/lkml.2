Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2K2FR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:17:26 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55357 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188Ab2K2FRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:17:24 -0500
X-Sasl-enc: DHVFhtRqlYG94GWGf+BUFMT6wI2HsenqipW3pF99Lpqs 1354166243
Date: Wed, 28 Nov 2012 21:19:02 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the tip
 tree
Message-ID: <20121129051902.GF4375@kroah.com>
References: <20121129152411.5333767f38065751b4723663@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129152411.5333767f38065751b4723663@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:24:11PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> lib/Makefile between commit e6459606b04e ("lib: Add early cpio decoder")
> from the tip tree and commit 610141ee651c ("lib: kobject_uevent is no
> longer dependant on CONFIG_HOTPLUG") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h

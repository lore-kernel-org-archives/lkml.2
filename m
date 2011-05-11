Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1EKSx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:53:27 -0400
Received: from kroah.org ([198.145.64.141]:47396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab1EKSx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:53:26 -0400
Date: Wed, 11 May 2011 11:52:32 -0700
From: Greg KH <greg@kroah.com>
To: anish <anish198519851985@gmail.com>
Cc: teddy.wang@siliconmotion.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [patch]: Coding style changes for Staging sm7xx
Message-ID: <20110511185232.GA25009@kroah.com>
References: <1305139294.2030.51.camel@anish-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305139294.2030.51.camel@anish-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:11:34AM +0530, anish wrote:
> Hi Greg,
> 
> This patch is for staging sm7xx 
> (Silicon Motion SM7XX frame buffer device).
> Patch contains some coding style changes.
> 
> I have compiled and built it against linus tree.

You should always do this against the linux-next tree, otherwise it
probably will not apply due to the few hundred pending patches already
queued up for the next merge window.

Please redo it against the linux-next tree and resend with the below
changes as well.

> Please find the patch as attachment and checked with checkpatch.
> 
> ps:this is my first patch for linux kernel.
> Regards,
> anish

> >From 1c66ca66cf230dfa610fc1a899c45f4ac3cb6070 Mon Sep 17 00:00:00 2001
> From: anish kumar <anish198519851985@gmail.com>

Please don't attach patches, include them as the whole email.

> Date: Wed, 11 May 2011 23:12:53 +0530
> Subject: [PATCH 1/2] Coding style changes to align with linux

Please be more descriptive, what does this mean?

Also, where is patch 2/2?

> Signed-off-by: anish<anish198519851985@gmail.com>

I need a real, and full, name here.

As for the patch itself, you are doing a lot of different "cleanups"
here, please split them out into one-type-of-cleanup-per-patch and
resend them as multiple patches.

hope this helps,

greg k-h

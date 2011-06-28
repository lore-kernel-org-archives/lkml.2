Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab1F1V0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:26:44 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51317 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab1F1V0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:26:39 -0400
X-Sasl-enc: MA/TZvt6meEKeU4com5PA1lNs1IkZckuaLsOl+GTqwkv 1309296398
Date: Tue, 28 Jun 2011 14:18:59 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/29] gma500: Ensure the frame buffer has a linear
 virtual mapping
Message-ID: <20110628211859.GA23217@kroah.com>
References: <20110616160104.6039.44019.stgit@localhost.localdomain>
 <20110616160642.6039.31781.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616160642.6039.31781.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 05:07:01PM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> We need this for the framebuffer in order to ensure that the kernel
> framebuffer layer can handle it when using KMS. Except for the base
> framebuffer this isn't a concern.
> 
> Add an npage field to the gtt as too many copies of the page calculation
> are getting spread around the code.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/staging/gma500/psb_fb.c  |   47 ++++++++++++++++++++++++--------------
>  drivers/staging/gma500/psb_fb.h  |    1 +
>  drivers/staging/gma500/psb_gtt.c |   18 ++++++---------
>  drivers/staging/gma500/psb_gtt.h |    5 ++--
>  4 files changed, 42 insertions(+), 29 deletions(-)

This doesn't apply:

patching file drivers/staging/gma500/psb_fb.c
patching file drivers/staging/gma500/psb_fb.h
patching file drivers/staging/gma500/psb_gtt.c
Hunk #1 FAILED at 79.
Hunk #3 FAILED at 120.
Hunk #5 FAILED at 149.
Hunk #7 FAILED at 193.
4 out of 7 hunks FAILED -- saving rejects to file drivers/staging/gma500/psb_gtt.c.rej
patching file drivers/staging/gma500/psb_gtt.h

Any ideas?

Is there drm changes in linux-next for this driver that I don't have?

If so, maybe we need to just start sending these patches through that tree?

greg k-h

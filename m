Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1HIQar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:30:47 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42161 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab1HIQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:30:46 -0400
X-Sasl-enc: BXYH/NuUvlcZRgCaaaWfjOy9AzKxgJlpplJGGh28upwp 1312907444
Date: Tue, 9 Aug 2011 09:13:15 -0700
From: Greg KH <greg@kroah.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Subject: Re: [stable] [PATCH] hpsa: fix physical device lun and target
 numbering problem
Message-ID: <20110809161315.GA8756@kroah.com>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 08:18:01AM -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> If a physical device exposed to the OS by hpsa
> is replaced (e.g. one hot plug tape drive is replaced
> by another, or a tape drive is placed into "OBDR" mode
> in which it acts like a CD-ROM device) and a rescan is
> initiated, the replaced device will be added to the
> SCSI midlayer with target and lun numbers set to -1.
> After that, a panic is likely to ensue.  When a physical
> device is replaced, the lun and target number should be
> preserved.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

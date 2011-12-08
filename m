Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab1LHNaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:30:12 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:46405 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1LHNaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:30:08 -0500
Date: Thu, 8 Dec 2011 14:29:46 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/30] Staging: comedi: fix printk issue in pcmuio.c
Message-ID: <20111208132946.GC6385@local>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323348745-31477-9-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323348745-31477-9-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 06:22:04PM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the pcmuio.c file that fixes up a
> printk warning found by the checkpatch.pl tool.
> 
> Added KERN_facility levels for printks.

You shouldn't use printk, use the dev_* macros, e.g. dev_warn, dev_err...

Thanks,
Hans

> 
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
>  drivers/staging/comedi/drivers/pcmuio.c |   23 +++++++++++------------
>  1 files changed, 11 insertions(+), 12 deletions(-)

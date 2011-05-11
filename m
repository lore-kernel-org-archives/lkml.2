Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1EKPzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:55:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:51998 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab1EKPzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:55:47 -0400
Date: Wed, 11 May 2011 08:55:35 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ASoC: Update cx20442 for TTY API change
Message-ID: <20110511155535.GB20920@suse.de>
References: <1305122744-30197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305122744-30197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 04:05:44PM +0200, Mark Brown wrote:
> receive_buf() was recently changed to return the number of bytes
> received but the cx20442 driver wasn't updated to match the new API.
> I don't have any hardware but since we don't actually appears to be
> listening to the data at all just report that we accepted all the data
> that was offered to us.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Liam Girdwood <lrg@ti.com>
> ---
> 
> This is a bug fix on top of "tty: make receive_buf() return the amout of
> bytes received"
> 
>  sound/soc/codecs/cx20442.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)

Do you want me to take this through the tty tree, or do you want to take
it through the SOC sound tree?  If you want to do it, that's fine with
me, whatever is easier for you.

thanks,

greg k-h

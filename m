Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1EKQ1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:27:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:53516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab1EKQ1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:27:31 -0400
Date: Wed, 11 May 2011 09:27:04 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ASoC: Update cx20442 for TTY API change
Message-ID: <20110511162704.GA22310@suse.de>
References: <1305122744-30197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110511155535.GB20920@suse.de>
 <20110511161131.GB31593@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511161131.GB31593@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 06:11:31PM +0200, Mark Brown wrote:
> On Wed, May 11, 2011 at 08:55:35AM -0700, Greg KH wrote:
> 
> > Do you want me to take this through the tty tree, or do you want to take
> > it through the SOC sound tree?  If you want to do it, that's fine with
> > me, whatever is easier for you.
> 
> Please apply it to your tree - the problem that this fixes was
> introduced by a patch in your tree in -next so it'd introduce breakage
> in my tree if I'd applied it anyway.

Doh, you are right, sorry, I'll go queue it up.

greg k-h

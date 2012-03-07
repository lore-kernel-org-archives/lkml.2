Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2CGFwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:52:05 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46982 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab2CGFwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:52:03 -0500
X-Sasl-enc: UrNFO7vBbuaOagBASd21g6b6pnSxlj7deAYin5C4FcS4 1331099518
Date: Tue, 6 Mar 2012 21:48:59 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        jbarnes@virtuousgeek.org, stable@kernel.org
Subject: Re: [PATCH] Ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120307054859.GB7775@kroah.com>
References: <1331059309-4335-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331059309-4335-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 01:41:49PM -0500, Matthew Garrett wrote:
> Right now we won't touch ASPM state if ASPM is disabled, except in the case
> where we find a device that appears to be too old to reliably support ASPM.
> Right now we'll clear it in that case, which is almost certainly the wrong
> thing to do. The easiest way around this is just to disable the blacklisting
> when ASPM is disabled.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: stable@kernel.org

That's <stable@vger.kernel.org> if we want to get it right :)

Anyway, Jesse, this needs to get into 3.3-final to prevent
regressions...

thanks,

greg k-h

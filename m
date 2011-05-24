Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1EXM5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:57:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab1EXM5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:57:31 -0400
Date: Tue, 24 May 2011 05:36:25 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Arnd Bergmann <arnd@arndb.de>,
        John Williams <john.williams@petalogix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v5] uio/pdrv_genirq: Add OF support
Message-ID: <20110524123625.GC31517@suse.de>
References: <1304577644-4024-1-git-send-email-monstr@monstr.eu>
 <4DDB960F.4050902@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDB960F.4050902@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 01:27:11PM +0200, Michal Simek wrote:
> Hi Greg,
> 
> can you please add it to your tree? I see you have sent pull request.

It's too late for the merge window for this, sorry.  I needed to have
this before it opened up, and in the linux-next tree for a week or so
before that.

Sorry.

Can you resend it in a format that I can apply it in, as well as getting
an ack from Hans?  I'll be glad to queue it up for the next major
release after this if you do that.

thanks,

greg k-h

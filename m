Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab1EMQXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:23:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab1EMQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:23:49 -0400
Date: Fri, 13 May 2011 09:20:54 -0700
From: Greg KH <gregkh@suse.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-usb@vger.kernel.org, sshtylyov@mvista.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] usb/gadget: at91sam9g20 fix end point max packet size
Message-ID: <20110513162054.GC2728@suse.de>
References: <1305042888-19401-1-git-send-email-plagnioj@jcrosoft.com>
 <1305298982-5789-1-git-send-email-plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305298982-5789-1-git-send-email-plagnioj@jcrosoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 05:03:02PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> on 9g20 they are the same as the 9260
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Resent upon Greg's request.
> Based on current linux-next.
> Applies cleanly on current linus' tree (2.6.39-rc7+)
> 
> BTW, can we imagine it going to mainline before .39-final in a "fixes" pull
> request to Linus from a at91 tree?

No, as I don't think this is a bug-fix-only-for-regression, is it?

It looks to be a "fix for new hardware" type thing, right?

And is this really the correct way to do this for the .40 kernel, which
is where I would be queueing this up for?

thanks,

greg k-h

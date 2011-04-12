Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab1DLVqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:46:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44859 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab1DLVqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:46:37 -0400
Date: Tue, 12 Apr 2011 22:46:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS
Message-ID: <20110412214621.GH7806@n2100.arm.linux.org.uk>
References: <1302300518-7523-1-git-send-email-sboyd@codeaurora.org> <alpine.LNX.2.00.1104101904000.17706@swampdragon.chaosbits.net> <4DA33720.5020206@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA33720.5020206@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 10:15:12AM -0700, Stephen Boyd wrote:
> > But, I see a lot of *_defconfig files in my copy of the tree that 
> > reference the option :
> >
> [snip]
> > shouldn't those lines be removed as well?
> >
> > I can submit a patch, but I thought you'd rather do it yourself..
> >
> 
> I was concerned that it would be more churn in the defconfigs. I can
> make a patch for that too though. Or we could just wait for the
> defconfigs to be regenerated and then the symbols would be dropped?

Two points here:

1. if it removes stuff, that's good.
2. but it has the potential to cause conflicts when other defconfig
   updates happen.

I think (2) outweighs (1), and as it's only one line, I agree with the
idea of just leaving it for when the defconfigs get updated.  We need
more effort spent on consolidating the bigger fish...

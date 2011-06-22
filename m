Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab1FVPla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:41:30 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43948 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab1FVPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:41:29 -0400
X-Sasl-enc: elAN1o0qwPUIqXhfPRXHyHVnsGIhKslV8V3ndfChGiDX 1308757288
Date: Wed, 22 Jun 2011 08:39:10 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: comedi doesn't build on several architectures
Message-ID: <20110622153910.GA19027@kroah.com>
References: <20110621.194925.1313933193955144936.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621.194925.1313933193955144936.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 07:49:25PM -0700, David Miller wrote:
> 
> It depends upon PAGE_KERNEL_NOCACHE which only a handful of
> platforms define.

Yes, sorry, I'm working on fixing them and will do so next week when I
return from vacation.

> Really, enabling staging in Linus's tree with all this build fallout
> was not the wisest.  It's blowing up all of my allmodconfig test
> builds now.
> 
> Stick it to -next first next time.

Linus wanted it now, and as it had been passing the 'randconfig' builds
by Randy and others for a long time, I figured it was safe to do this.

I'll get these resolved next week.

thanks,

greg k-h

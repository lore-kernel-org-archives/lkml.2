Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1HRPGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:06:52 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37063 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006Ab1HRPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:06:51 -0400
X-Sasl-enc: WjiaQAY8UBwy9xXrHDlMQF+lA5qRX80hXp7htqFU2gA0 1313680009
Date: Thu, 18 Aug 2011 07:55:07 -0700
From: Greg KH <greg@kroah.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] MAINTAINERS: add myself as co-maintainer for OMAP USB
Message-ID: <20110818145507.GA7012@kroah.com>
References: <1313664504-956-1-git-send-email-gadiyar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313664504-956-1-git-send-email-gadiyar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 04:18:24PM +0530, Anand Gadiyar wrote:
> I'd like to help co-maintain OMAP USB support. I've helped
> out in the past when Felipe was away and would like make
> it official.

Traditionally people are asked to be a maintainer, or they volunteer to
take over unmaintained projects.  The only time I've see co-maintainers,
is for larger projects, and then, it was a group decision.

For something as "small" as musb, what is the benefit to anyone to have
more than one maintainer?

It seems to me that things are finally settling down with the recent
musb mess, and I've been extremely happy with how Felipe has been
handling things, and I honestly don't want to see that change at the
moment.

So I'd stick with what we have now, unless you feel there are issues
with how Felipe is handling things, and if so, you should take that up
directly with him and only if that doesn't work out, me.

thanks,

greg k-h

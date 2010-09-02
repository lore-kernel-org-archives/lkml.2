Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0IBCB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:01:27 -0400
Received: from kroah.org ([198.145.64.141]:37019 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab0IBCB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:01:26 -0400
Date: Wed, 1 Sep 2010 19:00:55 -0700
From: Greg KH <greg@kroah.com>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, gregkh@suse.de,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH] serial: uartlite: Remove obscure loop from
 ulite_get_poll_char
Message-ID: <20100902020055.GE5117@kroah.com>
References: <1282740904-1244-1-git-send-email-monstr@monstr.eu>
 <1282740904-1244-2-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282740904-1244-2-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 02:55:04PM +0200, Michal Simek wrote:
> The previous patch
> "serial: Add CONSOLE_POLL support for uartlite"
> (sha1 id 52ea4a7ef12f286bd68d13a93daaa688f56a1e14)
> contained obcure loop in ulite_get_poll_char function.

I've merged this with the original patch so as to not have a problem.

thanks,

greg k-h

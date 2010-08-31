Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0HaAd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:33:26 -0400
Received: from kroah.org ([198.145.64.141]:58923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab0HaAdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:33:25 -0400
Date: Mon, 30 Aug 2010 17:27:56 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35
Message-ID: <20100831002756.GA8304@kroah.com>
References: <1281140943.4035.7.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1281140943.4035.7.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 05:29:03PM -0700, David Cross wrote:
> Re-Re-Re-Re-Re-sending with unnecessary files removed, line wrap turned off in
> new email client, Signed-off-by included in the correct place, and TODO file added.

I get a build error when I try to build this driver:
	drivers/staging/westbridge/astoria/block/../include/linux/westbridge/cyasmisc.h:521:2: error: expected declaration specifiers or ‘...’ before ‘cy_as_hal_device_tag’

It looks like the #include mess isn't working quite properly.

Also note that this driver is building on an x86-64 platform, which is
something that you probably don't want :)

So, for now, I'll just mark the driver as CONFIG_BROKEN and can you send
me some Kconfig patches against the next linux-next release which should
have this driver in it, so that it will build properly?

thanks,

greg k-h

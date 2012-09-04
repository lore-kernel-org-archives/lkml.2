Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2IDV2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:28:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37691 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2IDV2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:28:01 -0400
Date: Tue, 4 Sep 2012 14:25:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Baodong Chen <chenbdchenbd@gmail.com>, devel@driverdev.osuosl.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:fixed code to fit tty_driver's kref filed fixed
 code to fit tty_driver's kref filed for drivers/staging/net/pc300_tty.c
Message-ID: <20120904212529.GA6830@kroah.com>
References: <1346074458-2659-1-git-send-email-chenbdchenbd@gmail.com>
 <503F6C52.6030100@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503F6C52.6030100@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 03:36:18PM +0200, Jiri Slaby wrote:
> On 08/27/2012 03:34 PM, Baodong Chen wrote:
> 
> Sorry, I do not get this change. You should not touch tty_driver.kref at
> all.

Yeah, that's not ok, it's now dropped from my patch queue.

greg k-h

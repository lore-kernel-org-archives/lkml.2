Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2DGHZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 03:25:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34732 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2DGHZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 03:25:29 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio/sodaville: Convert sodaville driver to new irqdomain API
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Torben Hohn <torbenh@linutronix.de>
In-Reply-To: <20120406101236.GD5734@linutronix.de>
References: <1332968546-12901-1-git-send-email-grant.likely@secretlab.ca> <20120406101236.GD5734@linutronix.de>
Date: Fri, 06 Apr 2012 20:39:12 -0700
Message-Id: <20120407033912.7D0C43E23AF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012 12:12:36 +0200, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> * Grant Likely | 2012-03-28 15:02:26 [-0600]:
> 
> >Hi guys,
> Hi Grant,
> 
> sorry for the long delay.
> 
> >This patch fixes the build failure for the sodaville driver, but I've got
> >no way to test it.  Please take a look before I merge it.
> 
> It looks good. I don't have the board around and I haven't get around to
> look at the irq host changes. However, you can add my acked-by while
> merging.

Okay, thanks.  I'll merge it.

g.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1ADU1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:27:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:37155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab1ADU1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:27:31 -0500
Date: Tue, 4 Jan 2011 12:27:18 -0800
From: Greg KH <gregkh@suse.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 0/2] Annotate gpio-configuration with __must_check
Message-ID: <20110104202718.GA31444@suse.de>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 05:51:06PM +0100, Wolfram Sang wrote:
> Here is a small series generating a lot of warnings, especially in board
> bringup-files. Still, I think it is worthwhile to be strict about checking
> return values of gpio-configuration-functions. My suggestion to keep the noise
> a bit lower is to put it into linux-next for one cycle and then merge it for
> 2.6.39? That should give people some time to fix the issues in time. Looking
> forward to comments.

It's ok to add this type of thing, but please, go through and fix the
warnings at the same time.  Otherwise it's a bit rude to force others to
fix their code for something that you did.

Care to also send those patches along?

thanks,

greg k-h

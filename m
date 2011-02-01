Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1BACog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 21:44:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:49085 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab1BACof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 21:44:35 -0500
Date: Mon, 31 Jan 2011 18:42:49 -0800
From: Greg KH <gregkh@suse.de>
To: Timo von Holtz <tvh@informatik.uni-kiel.de>
Cc: shemminger@vyatta.com, error27@gmail.com, arnd@arndb.de, jj@chaosbits.net,
        joe@perches.com, eric.dumazet@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: fixed coding style issues
Message-ID: <20110201024249.GB2634@suse.de>
References: <1296525024-21898-1-git-send-email-tvh@informatik.uni-kiel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296525024-21898-1-git-send-email-tvh@informatik.uni-kiel.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 02:50:24AM +0100, Timo von Holtz wrote:
> Fixed some coding style issues

Which ones?

With such a huge patch, it's best to break it down by type of coding
style cleanup, to make it easier to review and apply.  This is almost
too big to review as-is :(

thanks,

greg k-h

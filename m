Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0H1QyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:54:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57900 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab0H1QyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:54:01 -0400
Date: Sat, 28 Aug 2010 18:53:59 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Brownell <david-b@pacbell.net>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/usb/gadget: Remove double test
In-Reply-To: <581556.29157.qm@web180314.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.64.1008281852450.13508@ask.diku.dk>
References: <581556.29157.qm@web180314.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Aug 2010, David Brownell wrote:

> Please update $SUBJECT to say which driver is
> affected;

Done.

> it's not everything in that directory,
> and accurate GIT summaries help a lot.

Is there some sort of rule that can be followed?  For example, if the 
patch affects only one, file, should that file be named?  What if the 
patch affects only two files?

thanks,
julia

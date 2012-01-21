Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab2AURN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 12:13:59 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35632 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab2AURN4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 12:13:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120121155235.GN3294@mwanda>
References: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
	<1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
	<20120121155235.GN3294@mwanda>
Date: Sat, 21 Jan 2012 09:13:56 -0800
Message-ID: <CAEMzQTbgr58FXHvDpqu3Gak5sNu7s8=dCdNk__YkWQzUUfy7oQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] xgifb: checkpatch cleanup, printk() KERN_*
From: sam hansen <solid.se7en@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It doesn't make sense to do this.  KERN_ERR puts a "<3>" in front of
> the line so we know how important it is, but it's a blank line
> because of the "\n" at the start.
>
> Also the should probably be using pr_err() or dev_err().
>
> ...
>
> These put a "<3>" in the middle of the line which doesn't help
> anyone.  Rewrite it so it's on one line.  Get rid of the OK line.

Ah yes.  I will fold things up so that printk isn't adding level
messages in the middle of the line.  In the case where the dmesg line
is incrementally being built up, I may patch the generating logic so
everything is made from a single call to printk.

Thanks for the feedback.  I am just picking this up and this is my 2nd
patch (set?) ever :)

~s

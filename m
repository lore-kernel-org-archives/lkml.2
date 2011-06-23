Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934396Ab1FWSsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:48:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57376 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932831Ab1FWSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:48:12 -0400
Date: Thu, 23 Jun 2011 14:48:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: stable@kernel.org, <linux-kernel@vger.kernel.org>,
        <stable-review@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 024/247] USB: prevent buggy hubs from crashing the
 USB stack
In-Reply-To: <1308849690-14530-25-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1106231438530.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Paul Gortmaker wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit d199c96d41d80a567493e12b8e96ea056a1350c1 upstream.
> 
> If anyone comes across a high-speed hub that (by mistake or by design)
> claims to have no Transaction Translators, plugging a full- or
> low-speed device into it will cause the USB stack to crash.  This
> patch (as1446) prevents the problem by ignoring such devices, since
> the kernel has no way to communicate with them.

This commit had some unexpected fallout.  It shouldn't be merged unless 
the following upstream commits are also merged:

c5c69f3f0dcf9b569c8f3ad67f3af92cfcedac43
cee6a262550f53a13acfefbc1e3e5ff35c96182c
ec95d35a6bd0047f05fe8a21e6c52f8bb418da55

Alan Stern


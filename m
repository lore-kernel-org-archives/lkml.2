Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2GWT55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:57:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38573 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754508Ab2GWT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:57:56 -0400
Date: Mon, 23 Jul 2012 15:57:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeff Moyer <jmoyer@redhat.com>
cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, <amethyst623@163.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
In-Reply-To: <x49394ith90.fsf@segfault.boston.devel.redhat.com>
Message-ID: <Pine.LNX.4.44L0.1207231556070.1633-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Jeff Moyer wrote:

> > Jeff, does this also fix Bugzilla #43269?
> 
> First, this patch is wrong.  I posted another version later on that got
> merged for 3.5.
> 
> As for bug 43269, it does not look like the same symptoms, so I would
> not expect the patches I posted to resolve that issue.  Sorry.

Can you suggest someone who might be able to help with #43269?  It has 
been languishing since May.

Alan Stern


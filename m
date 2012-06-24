Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2FXRw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 13:52:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34616 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FXRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 13:52:28 -0400
Date: Sun, 24 Jun 2012 10:52:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Lange <thomas@corelatus.se>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] sched: clock wrap bug in 2.6.35-stable kills scheduling
Message-ID: <20120624175207.GA29455@kroah.com>
References: <4FE74F1B.6070803@corelatus.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE74F1B.6070803@corelatus.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 07:32:11PM +0200, Thomas Lange wrote:
> Commit 305e683 introduced a wrap bug that causes task scheduling to fail
> after sched_clock() wrap. On a 1000 HZ system with 32bit jiffies, this
> occurs after 49.7 days.
> 
> Bug was introduced in 2.6.35.12 and is still present in linux-2.6.35.y HEAD.

Is this an issue in 3.5-rc3?

2.6.35-stable really isn't maintained anymore, I would suggest upgrading
to a more modern kernel version.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2LVESV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:18:21 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35609 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2LVEST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:18:19 -0500
Date: Fri, 21 Dec 2012 20:21:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 21/25] tty/max3100: don't use [delayed_]work_pending()
Message-ID: <20121222042125.GA14389@kroah.com>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-22-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356141435-17340-22-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 05:57:11PM -0800, Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from max3100.  Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.

Please, feel free to take it through your tree:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

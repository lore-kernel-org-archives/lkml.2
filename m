Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2ITR77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:59:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61873 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2ITR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:59:58 -0400
Date: Thu, 20 Sep 2012 10:53:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
Message-ID: <20120920175340.GE28934@google.com>
References: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
 <1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
 <20120919145228.80f72f59.akpm@linux-foundation.org>
 <1348113942.16096.18.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348113942.16096.18.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 07:05:42AM +0300, Maxim Levitsky wrote:
> There can't be races in the driver, since it contains a single thread
> that does all the IO it got from block layer.
> The thread is awaken each time the request function of block device is
> called.
> This why I didn't do much locking in here. In addition I found out that
> this is quite common way to implement a block device driver.

Please use workqueue instead of raw kthread.

Thanks!

-- 
tejun

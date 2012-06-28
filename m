Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab2F1QJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:09:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45755 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2F1QI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:08:59 -0400
Date: Thu, 28 Jun 2012 09:08:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Paul Rolland <rol@as2917.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: 3.5.0-rc3 - Issue with CFQ and cgroup
Message-ID: <20120628160855.GB22641@google.com>
References: <20120627195808.31714295@tux.DEF.witbe.net>
 <20120627182202.GO15811@google.com>
 <20120628095103.3c6c0a1e@tux.DEF.witbe.net>
 <20120628155754.GA22641@google.com>
 <20120628180443.01242645@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628180443.01242645@tux.DEF.witbe.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 06:04:43PM +0200, Paul Rolland wrote:
> What I did :
> mkdir tejun
> cd tejun
> git init
> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> for-linus

You cloned block tree into for-linus directory and then implicitly
used the master branch of the block tree, which is mainline.  What
should have been done are...

* git clone git://git.kernel....block.git block
* cd block
* git checkout for-linus

Thanks.

-- 
tejun

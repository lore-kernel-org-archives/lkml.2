Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2DATi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:38:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2DATiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:38:25 -0400
Date: Sun, 1 Apr 2012 15:38:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file handling
Message-ID: <20120401193816.GA6116@redhat.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 03:51:10PM -0700, Tejun Heo wrote:

[..]
> This patchset is an attempt at bringing some sanity to blkcg config
> and stat file handling.  It makes use of the pending dynamic cgroup
> file type addition / removal support [1], which will be merged into
> cgroup/for-3.5 once 3.4-rc1 is released.

Thanks Tejun. This looks like a nice cleanup. Especially the stat part.
It was very messy in blkcg core code. Now atleast it is clear who owns what
file and who needs per cpu stats etc. And new policies should be easily
able to define their own cgroup files.

Thanks
Vivek

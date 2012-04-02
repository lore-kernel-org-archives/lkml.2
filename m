Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2DBSz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:55:27 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57126 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2DBSz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:55:26 -0400
Date: Mon, 2 Apr 2012 11:55:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [GIT PULL] block/for-3.5/core: pull in cgroup/for-3.5
Message-ID: <20120402185522.GB16226@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120401200306.GB9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120402115905.cbca9c04113e543163bdb5f2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402115905.cbca9c04113e543163bdb5f2@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On Mon, Apr 02, 2012 at 11:59:05AM +1000, Stephen Rothwell wrote:
> today.  The best way to proceed is for the parts of the cgroup tree that
> the block tree will depend on (which may be the entire current cgroup
> tree) should be in a separate, stable (i.e. non rebasing/rewriting)
> branch that can be merged into both the cgroup and block trees.

Yeap, that's the intention of this pull request.  cgroup/for-3.5 is
already stable.  We just need it to be pulled into block/for-3.5/core.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab2DBTY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:24:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35942 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2DBTYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:24:55 -0400
Message-ID: <4F79FCF7.40909@kernel.dk>
Date: Mon, 02 Apr 2012 12:24:39 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Vivek Goyal <vgoyal@redhat.com>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [GIT PULL] block/for-3.5/core: pull in cgroup/for-3.5
References: <20120401200306.GB9230@dhcp-172-17-108-109.mtv.corp.google.com> <20120402115905.cbca9c04113e543163bdb5f2@canb.auug.org.au> <20120402185522.GB16226@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120402185522.GB16226@dhcp-172-17-108-109.mtv.corp.google.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-02 11:55, Tejun Heo wrote:
> Hello, Stephen.
> 
> On Mon, Apr 02, 2012 at 11:59:05AM +1000, Stephen Rothwell wrote:
>> today.  The best way to proceed is for the parts of the cgroup tree that
>> the block tree will depend on (which may be the entire current cgroup
>> tree) should be in a separate, stable (i.e. non rebasing/rewriting)
>> branch that can be merged into both the cgroup and block trees.
> 
> Yeap, that's the intention of this pull request.  cgroup/for-3.5 is
> already stable.  We just need it to be pulled into block/for-3.5/core.

It's pulled in.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab2DBTu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:50:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41934 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2DBTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:50:28 -0400
Date: Mon, 2 Apr 2012 12:50:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Vivek Goyal <vgoyal@redhat.com>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [GIT PULL] block/for-3.5/core: pull in cgroup/for-3.5
Message-ID: <20120402195024.GA17175@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120401200306.GB9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120402115905.cbca9c04113e543163bdb5f2@canb.auug.org.au>
 <20120402185522.GB16226@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F79FCF7.40909@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F79FCF7.40909@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 12:24:39PM -0700, Jens Axboe wrote:
> On 2012-04-02 11:55, Tejun Heo wrote:
> > Hello, Stephen.
> > 
> > On Mon, Apr 02, 2012 at 11:59:05AM +1000, Stephen Rothwell wrote:
> >> today.  The best way to proceed is for the parts of the cgroup tree that
> >> the block tree will depend on (which may be the entire current cgroup
> >> tree) should be in a separate, stable (i.e. non rebasing/rewriting)
> >> branch that can be merged into both the cgroup and block trees.
> > 
> > Yeap, that's the intention of this pull request.  cgroup/for-3.5 is
> > already stable.  We just need it to be pulled into block/for-3.5/core.
> 
> It's pulled in.

Great, now we can merge the conf/file restructuring patchset.  Will
write in that thread.

Thanks.

-- 
tejun

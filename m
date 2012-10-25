Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041Ab2JYSMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:12:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758601Ab2JYSMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:12:54 -0400
Date: Thu, 25 Oct 2012 14:12:48 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] fs: xattr: rewrite simple_xattr_set()
Message-ID: <20121025181248.GH14085@redhat.com>
References: <20121025152613.GF14085@redhat.com>
 <20121025173326.GH11442@htj.dyndns.org>
 <20121025175412.GG14085@redhat.com>
 <CAOS58YMJBNquaeP7rBzWu8vTWukAT3itH+qSt0cJxMmpTm0YEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YMJBNquaeP7rBzWu8vTWukAT3itH+qSt0cJxMmpTm0YEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 10:59:35AM -0700, Tejun Heo wrote:
> On Thu, Oct 25, 2012 at 10:54 AM, Aristeu Rozanski <aris@redhat.com> wrote:
> >> So, it returns 0 on success and 1 on failure, which in itself isn't a
> >> particularly good idea.
> >
> > you mean it should return -ENODATA instead?
> 
> Yeap, this is a bug, right?  We end up passing that 1 to the set_xattr caller.

yes, will resubmit

Thanks!

-- 
Aristeu


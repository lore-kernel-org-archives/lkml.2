Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992495Ab2JYRyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:54:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934720Ab2JYRyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:54:17 -0400
Date: Thu, 25 Oct 2012 13:54:13 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] fs: xattr: rewrite simple_xattr_set()
Message-ID: <20121025175412.GG14085@redhat.com>
References: <20121025152613.GF14085@redhat.com>
 <20121025173326.GH11442@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025173326.GH11442@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 10:33:26AM -0700, Tejun Heo wrote:
> On Thu, Oct 25, 2012 at 11:26:14AM -0400, Aristeu Rozanski wrote:
> > -	return err;
> >  
> > +	return 1;
> > +}
> 
> So, it returns 0 on success and 1 on failure, which in itself isn't a
> particularly good idea.

you mean it should return -ENODATA instead?

-- 
Aristeu


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1DAH3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:29:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60871 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab1DAH3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HVi0oBnZCfK8nzYoqZYOBYTjzTdG6Sk0FbWO+4BQQnecPOi5TAD8cbPHSXsRBOoOcy
         zGuW5a7ijAA+jVcS7u8uWR11fpVW6gErCWZAjnInr6z2eePMN/iZgzWeAjwduWAt1w8c
         Jwf5pXlLDxX94aSjKftyy4c3KRYD+WNNoGqWI=
Date: Fri, 1 Apr 2011 09:29:35 +0200
From: Tejun Heo <tj@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2] percpu: unify input section names
Message-ID: <20110401072935.GH3385@htj.dyndns.org>
References: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 03:52:01PM -0400, Mike Frysinger wrote:
> The two percpu helper macros have the section names duplicated.  So create
> a new define to merge the two.  This also allows arches who need to link
> things more directly themselves to avoid duplicating the input sections in
> their linker script.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Looks good to me but can you please rebase it on top of the following
branch?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git fixes-2.6.39

You'll probably need to add @cacheline to the macro.

Thanks.

-- 
tejun

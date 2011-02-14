Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1BNLJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:09:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48527 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1BNLJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:09:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g3aqNCea8ga65mPxjBWLmJHWxX4feOngWjZtESpbwdZg30p+fc4EVa+UATRfUbh447
         FCDgj5WO7b52k9H60/sM611A5m/ueGFC9nlGAvfJsgdIRWNuQx2+oe6w6a8+DJGx/aPp
         XWt807ybBjcnhK8ilM9yNe3rVavxTcdec+Zf0=
Date: Mon, 14 Feb 2011 12:09:25 +0100
From: Tejun Heo <tj@kernel.org>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 06/26] x86-64, NUMA: Move *_numa_init() invocations
 into initmem_init()
Message-ID: <20110214110925.GD18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-7-git-send-email-tj@kernel.org>
 <20110214061047.GA7065@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214061047.GA7065@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:40:47AM +0530, Ankita Garg wrote:
> Hi,
> 
> On Sat, Feb 12, 2011 at 06:10:43PM +0100, Tejun Heo wrote:
> > There's no reason for these to live in setup_arch().  Move them inside
> > initmem_init().
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Cc: Brian Gerst <brgerst@gmail.com>
> > Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> > Cc: Shaohui Zheng <shaohui.zheng@intel.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: H. Peter Anvin <hpa@linux.intel.com>
> > ---
> >  arch/x86/include/asm/page_types.h |    2 +-
> >  arch/x86/kernel/setup.c           |   16 +---------------
> >  arch/x86/mm/init_64.c             |    2 +-
> >  arch/x86/mm/numa_64.c             |   16 +++++++++++++++-
> >  4 files changed, 18 insertions(+), 18 deletions(-)
> >
> 
> This will break 32bits.

Yeap along with the previous patch.  Will update 32bit accordingly.

Thanks.

-- 
tejun

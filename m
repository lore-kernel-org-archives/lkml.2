Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1F3Tvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1F3Tvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:51:44 -0400
Date: Thu, 30 Jun 2011 15:51:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 0/4] dynamic_debug
Message-ID: <20110630195139.GC2457@redhat.com>
References: <20110630163218.GA2457@redhat.com>
 <cover.1309457340.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1309457340.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 11:14:33AM -0700, Joe Perches wrote:
> Some improvements and cleanups to dynamic_debug
> 
> btw Jason:
> 
> You're not listed in MAINTAINERS for dynamic_debug.[ch].
> Maybe you should add yourself. 
> 

Yes, I need to do that.

Thanks,

-Jason


> Joe Perches (4):
>   dynamic_debug: Add __dynamic_dev_dbg
>   dynamic_debug: Consolidate prefix output to single routine
>   dynamic_debug: Remove uses of KERN_CONT in dynamic_emit_prefix
>   dynamic_debug: Convert printks to pr_<level>
> 
>  drivers/base/core.c           |    5 +-
>  include/linux/device.h        |    5 ++
>  include/linux/dynamic_debug.h |   10 +++-
>  lib/dynamic_debug.c           |  133 +++++++++++++++++++++++++++--------------
>  4 files changed, 103 insertions(+), 50 deletions(-)
> 
> -- 
> 1.7.6.rc1
> 

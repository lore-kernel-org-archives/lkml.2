Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1EUAHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab1EUAGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:06:54 -0400
Date: Fri, 20 May 2011 20:06:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: dpshah@google.com, namhyung@gmail.com
Subject: Re: [PATCH 0/3] block: Per cpu merge stats and cfq fix
Message-ID: <20110521000650.GA8026@redhat.com>
References: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 08:02:44PM -0400, Vivek Goyal wrote:
> Hi Jens,
> 
> Here is the patch for making merge stats per cpu. While scanning the code
> I also noticed that in one case I was not freeing up per cpu stats. First
> patch fixes it. I also included Namhyung Kim's bio merge fix.
> 
> Thanks
> Vivek
> 
> Vivek Goyal (3):
>   cfq-iosched: Fix a memory leak of per cpu stats for root group
>   cfq-iosched: Make IO merge related stats per cpu

Minor correction. Following patch author is Namhyung Kim.

Namhyung Kim(1)

>   block: call elv_bio_merged() when merged

Thanks
Vivek

> 
>  block/blk-cgroup.c  |   22 +++++++++++++++++-----
>  block/blk-cgroup.h  |    4 ++--
>  block/blk-core.c    |    2 ++
>  block/cfq-iosched.c |    5 +++++
>  4 files changed, 26 insertions(+), 7 deletions(-)
> 
> -- 
> 1.7.4.4

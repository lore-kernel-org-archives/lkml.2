Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0DOG4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:56:34 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48887 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab0DOG4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:56:32 -0400
Date: Thu, 15 Apr 2010 08:56:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Divyesh Shah <dpshah@google.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: linux-next: build failure after merge of the block tree
Message-ID: <20100415065630.GR27497@kernel.dk>
References: <20100415124222.8e0e7132.sfr@canb.auug.org.au> <r2kaf41c7c41004142223m1464fd07u5617fe7332cb2ea@mail.gmail.com> <20100415161633.a7950127.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415161633.a7950127.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15 2010, Stephen Rothwell wrote:
> Hi Divyesh,
> 
> On Wed, 14 Apr 2010 22:23:25 -0700 Divyesh Shah <dpshah@google.com> wrote:
> >
> >      These errors seem to show up because the 2 symbols aren't
> > exported and hence when building as a module we don't have access to
> > these symbols. I'll send a patch to fix that shortly. Sorry for the
> > build breakage.
> 
> Thanks.

for-next is now updated.

-- 
Jens Axboe


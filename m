Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab0IPG3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:29:13 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41772 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab0IPG3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:29:12 -0400
Message-ID: <4C91B93A.7000905@kernel.dk>
Date: Thu, 16 Sep 2010 08:29:14 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build warning after merge of the final tree
References: <20100916150530.5789eb79.sfr@canb.auug.org.au>
In-Reply-To: <20100916150530.5789eb79.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-16 07:05, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) produced this warning:
> 
> drivers/scsi/aic7xxx_old.c: In function 'aic7xxx_buildscb':
> drivers/scsi/aic7xxx_old.c:10122: warning: unused variable 'req'
> 
> Introduced by commit 9cbbdca44ae1a6f512ea1e2be11ced8bbb9d430a ("block:
> remove spurious uses of REQ_HARDBARRIER").

Fixed that up, thanks.

-- 
Jens Axboe


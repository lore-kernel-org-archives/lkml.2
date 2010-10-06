Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab0JFP4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:56:53 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:41157 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759155Ab0JFP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:56:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _dp_7ssVM1mMHpDCqbZeoRMwubr4j.0lYA5o_ME3cCugyqn
 DGpspjEHwXwEp2USHtVKLTVZDMqQaXxSPXvvRdqG_v7O5GKTZ98OX9dpp0Vx
 pY3laIPjTnUQ63yxgrnomrOVXmYj95iUIRPHxlC9Ddu.CNaYyPlPGZQA4HuZ
 lzOFax6dUUfC7_lx3W3.y3oShY_cHjYxv8yK3FH8EqTzTIibC5BbNOwkymsR
 2mIytcdN6OSNI9ZgfnUoghrjGBJfx
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Oct 2010 10:56:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Mel Gorman <mel@csn.ul.ie>, npiggin@kernel.dk,
        yanmin_zhang@linux.intel.com
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
In-Reply-To: <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1010061054410.31538@router.home>
References: <20101005185725.088808842@linux.com> <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Pekka Enberg wrote:

> Are there any stability problems left? Have you tried other benchmarks
> (e.g. hackbench, sysbench)? Can we merge the series in smaller
> batches? For example, if we leave out the NUMA parts in the first
> stage, do we expect to see performance regressions?

I have tried hackbench but the number seem to be unstable on my system.
There may be various small optimizations still left to be done.

You cannot merge this without the patches up to the patch that implements
alien caches without performance issues. If you leave out the NUMA parts
then !NUMA is of course fine.

I would suggest to merge the cleanups first for the next upstream
merge cycle and give this patchset at least a whole -next cycle before
upstream merge.



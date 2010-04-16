Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0DPGHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:07:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58198 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab0DPGHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:07:04 -0400
Date: Fri, 16 Apr 2010 08:07:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: guijianfeng@cn.fujitsu.com, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH] blkio: Initialize blkg->stats_lock for the root cfqg
	too
Message-ID: <20100416060700.GD27497@kernel.dk>
References: <20100416040144.3739.94764.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416040144.3739.94764.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15 2010, Divyesh Shah wrote:
> This fixes the lockdep warning reported by Gui Jianfeng.

Thanks, applied.

-- 
Jens Axboe


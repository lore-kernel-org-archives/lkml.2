Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2LRR3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:29:37 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55142 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab2LRR3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:29:36 -0500
Date: Tue, 18 Dec 2012 09:24:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] workqueue: use new hashtable implementation
Message-ID: <20121218172414.GL1844@htj.dyndns.org>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
 <1355756497-15834-3-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355756497-15834-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 10:01:23AM -0500, Sasha Levin wrote:
> Switch workqueues to use the new hashtable implementation. This reduces the
> amount of generic unrelated code in the workqueues.
> 
> This patch depends on d9b482c ("hashtable: introduce a small and naive
> hashtable") which was merged in v3.6.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied to wq/for-3.9.  Thanks.

-- 
tejun

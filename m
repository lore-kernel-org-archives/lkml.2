Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab2LRQ7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:59:41 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:50963 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2LRQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:59:39 -0500
Date: Tue, 18 Dec 2012 08:59:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Xiaotian Feng <dannyfeng@tencent.com>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] megaraid: convert to work_struct
Message-ID: <20121218165932.GK1844@htj.dyndns.org>
References: <1355388798-12869-1-git-send-email-xtfeng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355388798-12869-1-git-send-email-xtfeng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 04:53:18PM +0800, Xiaotian Feng wrote:
> There's no need to use delayed work, convert to use work_struct and
> cancel_work_sync().
> 
> Requested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

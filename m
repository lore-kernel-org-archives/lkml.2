Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2BQWSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:18:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62285 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2BQWSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:18:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.138.194 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Fri, 17 Feb 2012 14:18:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] block: ioc_task_link() can't fail
Message-ID: <20120217221801.GL29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-6-git-send-email-tj@kernel.org>
 <20120217204108.GF26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217204108.GF26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 03:41:08PM -0500, Vivek Goyal wrote:
> On Thu, Feb 16, 2012 at 02:37:54PM -0800, Tejun Heo wrote:
> > ioc_task_link() is used to share %current's ioc on clone.  If
> > %current->is_context is set, %current is guaranteed to have refcount
> 
> Typo. s/is_context/io_context.

Will update.  Thanks.

-- 
tejun

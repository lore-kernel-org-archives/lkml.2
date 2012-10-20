Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2JTWxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 18:53:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62172 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2JTWxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 18:53:22 -0400
Date: Sat, 20 Oct 2012 15:53:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueue: trivial fix for return statement in
 work_busy()
Message-ID: <20121020225318.GA11442@htj.dyndns.org>
References: <Yes>
 <1350750607-2051-1-git-send-email-js1304@gmail.com>
 <1350750607-2051-3-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350750607-2051-3-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 01:30:06AM +0900, Joonsoo Kim wrote:
> Return type of work_busy() is unsigned int.
> There is return statement returning boolean value, 'false' in work_busy().
> It is not problem, because 'false' may be treated '0'.
> However, fixing it would make code robust.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Applied 1-2 to wq/for-3.8.

Thanks.

-- 
tejun

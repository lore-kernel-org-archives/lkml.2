Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1K1QJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:09:42 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39192 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K1QJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:09:40 -0500
Date: Mon, 28 Nov 2011 08:09:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] sysctl: Add the kernel.ns_last_pid control
Message-ID: <20111128160935.GC18864@google.com>
References: <4ED3A6F5.6070606@parallels.com>
 <20111128155315.GA18864@google.com>
 <4ED3B118.50502@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED3B118.50502@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 08:04:40PM +0400, Pavel Emelyanov wrote:
> > I would still prefer using set_last_pid() but if you insist to update
> > last_pid directly, please note the direct update in the comment on top
> > of set_last_pid() too.
> 
> It's already there in this patch.

Heh, indeed.  My eyes just skipped over them.  :)

Thanks.

-- 
tejun

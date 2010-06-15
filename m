Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0FON3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:29:38 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34337 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0FON3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FcK1SBQyoa95tTv6D9zdS9GfZsjN8KkgQz8XFr3LG2vyV3GuGACt19HbejNwCezzSE
         Uvlqje//x6NJFhLVjg6TEWTBQ8zu7O+e03W6Tg6e1NH3zGYFwiIYcK0mQIjjmrcGJCcb
         FL9duFr+NgAWkvZyDvFQmws937/ALYa7rfUdM=
Date: Tue, 15 Jun 2010 15:29:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH 08/30] workqueue: temporarily disable workqueue tracing
Message-ID: <20100615132926.GE5342@nowhere>
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <1276551467-21246-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276551467-21246-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:37:25PM +0200, Tejun Heo wrote:
> Strip tracing code from workqueue and disable workqueue tracing.  This
> is temporary measure till concurrency managed workqueue is complete.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/trace/Kconfig |    4 +++-
>  kernel/workqueue.c   |   14 +++-----------
>  2 files changed, 6 insertions(+), 12 deletions(-)



If the new workqueue implementation makes the workqueue tracing useless,
than please remove it. We can think about providing a more suitable
tracing for that later, once we have determined the interesting organic
points.


I'll be happy to help.


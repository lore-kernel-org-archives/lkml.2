Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0LVAHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:07:48 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:49179 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0LVAHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:07:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gyU76CX0IBp3rU4moThFOcXkxWPB+pgeq7uwUW3mxuZ3C/gu4gXOcFq0xesLLMAUoi
         z3I/1RsH6doeicDxzAQiDCE4kvIesiHKH2StYK60eeyaDgzMgoQ3Lm3F0MciulJ1tSjZ
         oV8/qX5cyXq/2z6i6z+m7fJh7z7DGUHndmQuM=
Date: Wed, 22 Dec 2010 03:07:42 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/30] battery: don't use flush_scheduled_work()
Message-ID: <20101222000742.GD24834@oksana.dev.rtsoft.ru>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-29-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1292086307-19211-29-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 05:51:45PM +0100, Tejun Heo wrote:
> flush_scheduled_work() is deprecated and scheduled to be removed.
> 
> In battery drivers, the work can be canceled on probe failure and
> removal and should be flushed on suspend.  Replace
> flush_scheduled_work() usages with direct cancels and flushes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
> This is part of a series to remove flush_scheduled_work() usage to
> prepare for deprecation of flush_scheduled_work().  Patches in this
> series are self contained and mostly straight-forward.
> 
> Please feel free to take it into the appropriate tree, or just ack it.
> In the latter case, I'll merge the patch through the workqueue tree
> during the next merge window.
> 
> If you're seeing this patch for the second time, it's because the
> commit hasn't showed up in mainline yet.  Please let me know what
> should be done.
> 
> Thank you.

I applied this to battery-2.6.git, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

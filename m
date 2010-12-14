Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab0LNQye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:54:34 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:54445 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab0LNQyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bpRaRSP4ToXAz0MP5QpzsjbweLjMfn1fWguhx6WQT4RCcBATyJfdq43j46KcVNUNmv
         gvVj5f4w4C68rMR7GR2h/NG902Sjh47BiUVobt6U3RI66B0BQwAOODOxpeOOlQv1PBP3
         L60YvD8WkmKWeZ4kxYjdujgxhRGkW8pFH7S0A=
Subject: Re: [PATCH 27/30] mtd: don't use flush_scheduled_work()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1292086307-19211-28-git-send-email-tj@kernel.org>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	 <1292086307-19211-28-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 18:53:53 +0200
Message-ID: <1292345633.2538.101.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-11 at 17:51 +0100, Tejun Heo wrote:
> flush_scheduled_work() is deprecated and scheduled to be removed.
> Directly flush cxt->work_{erase|write} on removal instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org
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

Pushed to l2-mtd-2.6.git, thanks. This means this will be merged to the
mtd tree a bit later and will go upstream.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


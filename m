Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0LXPOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 10:14:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0LXPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e9KOEvVIfFLT4zlCW7Z7Tg37ULpUO7IAjhB6GivaHlmxC3e2hqBtMaHfHJRTPzpVbf
         v9crknLa7vPSzwKGpxj8ajBnRu7w1lHOmiTwoe3tSEwWNXvUZcf03FaFYAilqrtCnW31
         jT7RsEVNIDIo4nHx3/q/EQdEv3DVhNUEgTGMI=
Date: Fri, 24 Dec 2010 16:14:47 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET] workqueue: another assorted flush_scheduled_work()
 removals
Message-ID: <20101224151447.GC11419@htj.dyndns.org>
References: <1292172499-21633-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292172499-21633-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 05:48:13PM +0100, Tejun Heo wrote:
> Hello,
> 
> This is another set of patches to remove flush_scheduled_work() users.
> 
>  0001-init-don-t-call-flush_scheduled_work-from-do_initcal.patch
>  0002-ioc4-use-static-work_struct-for-ioc4_load_modules.patch
>  0003-media-video-explicitly-flush-request_module-work.patch
>  0004-media-video-don-t-use-flush_scheduled_work.patch
>  0005-speedtch-don-t-abuse-struct-delayed_work.patch
>  0006-usb-don-t-use-flush_scheduled_work.patch

Merged into wq#for-next.  Thanks.

-- 
tejun

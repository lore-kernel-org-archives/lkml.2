Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1BTOKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 09:10:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32896 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1BTOKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 09:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hgd9mJ1Qi5N/frKkbC0r6cf0C5wVPc066/uekwT+2MH4zVOAcC6bFFBUGbejT4nHqJ
         VQRQavS9cNd1vTtf3rfwCvWe6PAAK6FwqrVhLwxNSR+EOkOxiy9hgXQz2ErJwteD6oGy
         NlI3ZElAZZrxon3InSlqdUubQG0zbguNFYgT4=
Date: Sun, 20 Feb 2011 22:10:04 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
Message-ID: <20110220141003.GA6006@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
 <1298207379.7998.11.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298207379.7998.11.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 02:09:39PM +0100, Mike Galbraith wrote:
> On Sun, 2011-02-20 at 15:08 +0800, Yong Zhang wrote:
> > Now enable/disable autogroup at runtime is just a flag,
> > it doesn't take effect on current process of the system.
> 
> Yup, they only move upon migration, which can take up to forever.

Yeah. so on UP, the user can have autogroup forever or not, and
sched_autogroup_enable is a nop.

> Linus
> didn't like the idea of an active on/off switch, so it got whacked.

Seems I missed that very thread.


Apart from runtime enable/disable issue, I think patch1~3 could
still be applied beause they really fix some problem or bring
some improvement.

Thanks,
Yong

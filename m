Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1APOEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 09:04:54 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13210 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1APOEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 09:04:52 -0500
Date: Sun, 16 Jan 2011 15:04:50 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: safford@watson.ibm.com, dhowells@redhat.com, safford@us.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Trusted and Encrypted Keys: fix up TSS_rawhmac() so
 wealways kfree() and remember to call va_end()
In-Reply-To: <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net> <1295011682.7804.2.camel@localhost.localdomain> <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp> <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Tetsuo Handa wrote:

> Tetsuo Handa wrote:
> > Please wait. That patch is incorrect. I'm making patch now.
> I'm doing "git pull" now. Using 2.6.37-git11 instead.
> 
> James Morris wrote:
> > It's queued in my for-linus branch, waiting to see what happens with 
> > http://marc.info/?l=linux-security-module&m=129494927918805&w=3
> 
> I think above patch is incorrect because va_end() might be called without
> va_start(). C says va_start() without va_end() causes undefined behavior.
> I think va_end() without va_start() causes undefined behavior as well.
> 

I agree. Your patches are better. Thanks.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.


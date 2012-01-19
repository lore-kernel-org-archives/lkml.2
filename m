Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2ASAzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:55:52 -0500
Received: from tundra.namei.org ([65.99.196.166]:55921 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab2ASAzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:55:51 -0500
Date: Thu, 19 Jan 2012 11:55:33 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v10 0/2] security: Yama LSM
In-Reply-To: <20120118184346.GT2618@outflux.net>
Message-ID: <alpine.LRH.2.00.1201191154550.30715@tundra.namei.org>
References: <1324498624-31868-1-git-send-email-keescook@chromium.org> <201112282116.AFE13558.FOLSHJMOOVQFtF@I-love.SAKURA.ne.jp> <20120118184346.GT2618@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012, Kees Cook wrote:

> Hi,
> 
> On Wed, Dec 28, 2011 at 09:16:51PM +0900, Tetsuo Handa wrote:
> > Since there seems to be no big problems/objections to this module,
> > I think this module is ready to go to 3.3 via security-testing tree.
> 
> Thanks Tetsuo!
> 
> James, any update on this? What are the next steps?

I'm planning to merge it with next once the 3.3 merge window closes.

-- 
James Morris
<jmorris@namei.org>

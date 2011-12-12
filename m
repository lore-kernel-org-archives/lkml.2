Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1LLGWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:22:21 -0500
Received: from tundra.namei.org ([65.99.196.166]:49914 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab1LLGWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:22:19 -0500
Date: Mon, 12 Dec 2011 17:22:10 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] tomoyo: add missing rcu_dereference()
In-Reply-To: <20111209003042.GA17905@www.outflux.net>
Message-ID: <alpine.LRH.2.00.1112121721590.4694@tundra.namei.org>
References: <20111209003042.GA17905@www.outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Kees Cook wrote:

> Adds a missed rcu_dereference() around real_parent.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to
git://selinuxproject.org/~jmorris/linux-security next


-- 
James Morris
<jmorris@namei.org>

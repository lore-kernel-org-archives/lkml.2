Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2DSDkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:40:46 -0400
Received: from tundra.namei.org ([65.99.196.166]:58306 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2DSDkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:40:45 -0400
Date: Thu, 19 Apr 2012 13:40:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: kernel-hardening@lists.openwall.com
cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        John Johansen <john.johansen@canonical.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, spender@grsecurity.net
Subject: Re: [kernel-hardening] [PATCH] Yama: add additional ptrace scopes
In-Reply-To: <20120416185645.GA13667@www.outflux.net>
Message-ID: <alpine.LRH.2.02.1204191340020.563@tundra.namei.org>
References: <20120416185645.GA13667@www.outflux.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Kees Cook wrote:

> This expands the available Yama ptrace restrictions to include two more
> modes. Mode 2 requires CAP_SYS_PTRACE for PTRACE_ATTACH, and mode 3
> completely disables PTRACE_ATTACH (and locks the sysctl).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>

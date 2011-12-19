Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1LSAd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:33:27 -0500
Received: from tundra.namei.org ([65.99.196.166]:32780 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab1LSAdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:33:25 -0500
Date: Mon, 19 Dec 2011 11:33:10 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: kernel-hardening@lists.openwall.com
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
In-Reply-To: <1324017197-3292-3-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
References: <1324017197-3292-1-git-send-email-keescook@chromium.org> <1324017197-3292-3-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011, Kees Cook wrote:

> +#ifdef CONFIG_SECURITY_YAMA
> +	ns->ptrace_scope = parent_pid_ns->ptrace_scope;
> +#endif
> +

I'd like to see this implemented as an LSM hook, something like 
security_ptrace_set_scope().



- James
-- 
James Morris
<jmorris@namei.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1LSTlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:41:55 -0500
Received: from smtp.outflux.net ([198.145.64.163]:44665 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab1LSTlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:41:53 -0500
Date: Mon, 19 Dec 2011 11:41:36 -0800
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
Message-ID: <20111219194136.GG12321@outflux.net>
References: <1324017197-3292-1-git-send-email-keescook@chromium.org>
 <1324017197-3292-3-git-send-email-keescook@chromium.org>
 <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
Organization: Chromium
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Mon, Dec 19, 2011 at 11:33:10AM +1100, James Morris wrote:
> On Thu, 15 Dec 2011, Kees Cook wrote:
> > +#ifdef CONFIG_SECURITY_YAMA
> > +	ns->ptrace_scope = parent_pid_ns->ptrace_scope;
> > +#endif
> > +
> 
> I'd like to see this implemented as an LSM hook, something like 
> security_ptrace_set_scope().

I must be dense, but I fail to understand the purpose of this. The "ptrace
scope" implemented by Yama is a sysctl, not an system interface. I don't
understand why (or where) other LSMs would want to catch changing this.
Can you explain what you're looking for in more detail?

-Kees

-- 
Kees Cook

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0KPPzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:55:21 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52287 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0KPPzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:55:20 -0500
Date: Tue, 16 Nov 2010 07:54:18 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        torvalds@linux-foundation.org, joe@perches.com,
        drosenberg@vsecurity.com, mingo@elte.hu, eugeneteo@kernel.org,
        akpm@linux-foundation.org, jmorris@namei.org, morgan@kernel.org,
        casey@schaufler-ca.com, serge@hallyn.com
Subject: Re: [PATCH] capabilities/syslog: open code cap_syslog logic to fix
 build failure
Message-ID: <20101116155418.GL13854@outflux.net>
References: <20101115233628.6288.2303.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115233628.6288.2303.stgit@paris.rdu.redhat.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 06:36:29PM -0500, Eric Paris wrote:
> The addition of CONFIG_SECURITY_DMESG_RESTRICT resulted in a build failure
> when CONFIG_PRINTK=n.  This is because the capabilities code which used the
> new option was built even though the variable in question didn't exist.  The
> patch here fixes this by moving the capabilities checks out of the LSM and
> into the caller.  All (known) LSMs should have been calling the capabilities
> hook already so it actually makes the code organization better to eliminate
> the hook altogether.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: James Morris <jmorris@namei.org>

Acked-by: Kees Cook <kees.cook@canonical.com>

-- 
Kees Cook
Ubuntu Security Team

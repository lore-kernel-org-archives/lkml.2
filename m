Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab0GTXB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:01:28 -0400
Received: from tundra.namei.org ([65.99.196.166]:50421 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab0GTXB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:01:26 -0400
Date: Wed, 21 Jul 2010 09:01:24 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Yama: verify inode is symlink to avoid bind mounts
In-Reply-To: <20100714061845.GW6104@outflux.net>
Message-ID: <alpine.LRH.2.00.1007210901120.22161@tundra.namei.org>
References: <20100714061845.GW6104@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Kees Cook wrote:

> The inode_follow_link LSM hook is called in bind mount situations as
> well as for symlink situations, so we must explicitly check for the
> inode being a symlink to not reject bind mounts in 1777 directories,
> which seems to be a common NFSv4 configuration.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
> v2:
>  - actually set inode in time to use it.  *face palm*

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>

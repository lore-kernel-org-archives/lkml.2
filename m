Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2IGPdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:33:51 -0400
Received: from tundra.namei.org ([65.99.196.166]:47002 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2IGPbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:01 -0400
Date: Sat, 8 Sep 2012 01:25:36 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Yama: handle 32-bit userspace prctl
In-Reply-To: <20120827183813.GA23991@www.outflux.net>
Message-ID: <alpine.LRH.2.02.1209080125240.7301@tundra.namei.org>
References: <20120827183813.GA23991@www.outflux.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012, Kees Cook wrote:

> When running a 64-bit kernel and receiving prctls from a 32-bit
> userspace, the "-1" used as an unsigned long will end up being
> misdetected. The kernel is looking for 0xffffffffffffffff instead of
> 0xffffffff. Since prctl lacks a distinct compat interface, Yama needs
> to handle this translation itself. As such, support either value as
> meaning PR_SET_PTRACER_ANY, to avoid breaking the ABI for 64-bit.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


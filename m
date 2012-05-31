Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2EaIoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:44:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:40873 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab2EaIoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:44:09 -0400
Date: Thu, 31 May 2012 18:42:20 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: kosaki.motohiro@gmail.com
cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Chris Wright <chrisw@sous-sol.org>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] security: kill security_task_fix_setuid()
In-Reply-To: <1338451199-15396-1-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.LRH.2.02.1205311841530.26474@tundra.namei.org>
References: <1338451199-15396-1-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> commit 72fa5997 (move RLIMIT_NPROC check from set_user() to do_execve_common())
> pointed out set*uid() failure can cause a security problem.
> Thus, security_task_fix_setuid() potentially has the same issue. Any security
> module shouldn't use it. This patch kills it completely.
> 
> Luckily, any security module don't use it. then, this patch doesn't make any
> userland visible change.

Capabilities uses it.


-- 
James Morris
<jmorris@namei.org>

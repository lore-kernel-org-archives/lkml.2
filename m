Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2HTSJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:09:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59690 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab2HTSJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:09:29 -0400
Date: Mon, 20 Aug 2012 22:09:23 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH 07/21] userns: Use kgids for sysctl_ping_group_range
Message-ID: <20120820180923.GA13669@cachalot>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
 <1344889115-21610-7-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344889115-21610-7-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 13:18 -0700, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - Store sysctl_ping_group_range as a paire of kgid_t values
>   instead of a pair of gid_t values.
> - Move the kgid conversion work from ping_init_sock into ipv4_ping_group_range
> - For invalid cases reset to the default disabled state.
> 
> With the kgid_t conversion made part of the original value sanitation
> from userspace understand how the code will react becomes clearer
> and it becomes possible to set the sysctl ping group range from
> something other than the initial user namespace.
> 
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Looks good.

Acked-by: Vasiliy Kulikov <segoon@openwall.com>

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments

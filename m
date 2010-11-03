Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0KCRua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:50:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab0KCRu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:50:28 -0400
Date: Wed, 3 Nov 2010 13:50:26 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Ross Kirk <Ross.Kirk@nexor.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, eparis@redhat.com
Subject: Re: [PATCH] audit: error message typo correction
In-Reply-To: <DF69A264612A3D4B961979B6957E8CFB040F06D4@NEXCHANGE.nexor.co.uk>
Message-ID: <alpine.LNX.2.00.1011031350040.15851@pobox.suse.cz>
References: <DF69A264612A3D4B961979B6957E8CFB040F06D4@NEXCHANGE.nexor.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Ross Kirk wrote:

> 
> Fixes a typo in the error message raised by audit when auditd has died
> 
> Signed-off-by: Ross Kirk <ross.kirk@nexor.com>
> 
> --
> 
> diff -up a/kernel/audit.c b/kernel/audit.c 
> --- a/kernel/audit.c    2010-10-22 16:25:40.000000000 +0100
> +++ b/kernel/audit.c    2010-10-22 16:25:46.000000000 +0100
> @@ -400,7 +400,7 @@ static void kauditd_send_skb(struct sk_b
>         if (err < 0) {
>                 BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
>                 printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
> -               audit_log_lost("auditd dissapeared\n");
> +               audit_log_lost("auditd disappeared\n");
>                 audit_pid = 0;
>                 /* we might get lucky and get this in the next auditd */
>                 audit_hold_skb(skb);

Asi this is not in linux-next as of today, I have put it into trivial 
queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

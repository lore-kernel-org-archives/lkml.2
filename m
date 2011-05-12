Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1ELPoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:44:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab1ELPo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:44:29 -0400
Date: Thu, 12 May 2011 17:42:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110512154247.GC18599@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-10-git-send-email-tj@kernel.org> <20110511154854.GB23688@redhat.com> <20110511192902.GC24245@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511192902.GC24245@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Tejun Heo wrote:
>
> > Can't we push this patch ahead of these changes? I can merge it into
> > ptrace branch.
>
> It doesn't really fix the problem tho.  The whole thing is full of
> holes

Hmm. Could you explain?  (unless you mean ptrace holes)

> Anyways, yeah, sure.  I'll resend it as a separate patch.

Thanks, I'll aply the patch you sent today.

Oleg.


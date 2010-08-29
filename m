Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0H2LZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 07:25:27 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:54334 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752778Ab0H2LZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 07:25:26 -0400
Date: Sun, 29 Aug 2010 07:24:53 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <633505726.1479321283081093502.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C7A20F6.5070802@kernel.org>
Subject: Re: kdump regression compared to v2.6.35
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Tejun Heo" <tj@kernel.org> wrote:

> On 08/29/2010 09:01 AM, caiqian@redhat.com wrote:
> > Further bisect indicated this bad commit from the merge. Given kdump
> > kernel was running with maxcpus=1, I guess this work caused fs/bio.c
> > hung in the workqueue on UP. Reverted the whole merge let kdump work
> > again.
> 
> Can you please pull from the following git tree and see whether it
> fixes the problem?  There was a bug in nr_active accounting.
It had the same problem.
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus
> 
> Thanks.
> 
> -- 
> tejun
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

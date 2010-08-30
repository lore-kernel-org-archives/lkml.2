Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0H3KZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:25:16 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:33078 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755245Ab0H3KZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:25:14 -0400
Date: Mon, 30 Aug 2010 06:24:28 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1633441528.1498131283163868227.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C7B6C07.6010800@kernel.org>
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

> Hello,
> 
> On 08/30/2010 05:42 AM, CAI Qian wrote:
> >> Hmmm... I can't reproduce it here.  I wonder what the difference
> is.
> >> Can you please trigger sysrq-t after the boot is hung and post the
> >> result?
> > Sysrq keys did not work at this early stage of booting for me even
> > adding sysrq_always_enabled.
> 
> I see.  I'll prepare a debug patch which tries to catch long
> execution
> delays in workqueue but in the meantime can you please turn on
> hangcheck timer and see whether it triggers after the kernel hangs
> during boot?
Can't see any difference with hangcheck timer enabled.
> Thanks.
> 
> -- 
> tejun
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

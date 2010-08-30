Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0H3DnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:43:17 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:41994 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754616Ab0H3DnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:43:15 -0400
Date: Sun, 29 Aug 2010 23:42:53 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1888320510.1487031283139773505.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C7A5455.7060905@kernel.org>
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
> On 08/29/2010 02:03 PM, CAI Qian wrote:
> > 
> > ----- "Tejun Heo" <tj@kernel.org> wrote:
> > 
> >> On 08/29/2010 01:56 PM, CAI Qian wrote:
> >>> It is easy to reproduce by passing maxcpus=1 to the first kernel.
> >>
> >> Do you mean booting w/ maxcpus=1 hangs the first kernel even w/o
> >> kdump?
> > Yes, here was the log,
> 
> Hmmm... I can't reproduce it here.  I wonder what the difference is.
> Can you please trigger sysrq-t after the boot is hung and post the
> result?
Sysrq keys did not work at this early stage of booting for me even adding sysrq_always_enabled.
> Thanks.
> 
> -- 
> tejun

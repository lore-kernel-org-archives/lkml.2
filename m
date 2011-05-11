Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1EKRVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:21:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34197 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1EKRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:21:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the namespace tree
References: <20110511140900.bbafb560.sfr@canb.auug.org.au>
Date: Tue, 10 May 2011 21:21:12 -0700
In-Reply-To: <20110511140900.bbafb560.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Wed, 11 May 2011 14:09:00 +1000")
Message-ID: <m1hb91eukn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+6+dNx6itnxDxXJrDSXqUYdxnv2QAIi7A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> After merging the namespace tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> In file included from arch/powerpc/platforms/cell/spu_callbacks.c:49:
> arch/powerpc/include/asm/systbl.h:356: error: 'sys_setns' undeclared here (not in a function)
>
> Caused by commit e975ee91dcc1 ("ns: Wire up the setns system call").
> sys_setns should be declared in include/linux/syscalls.h.
>
> I have dropped the namespace tree for today.

Ouch.  I guess I must have missed something I will take a look.
My apologies for the trouble.

Eric


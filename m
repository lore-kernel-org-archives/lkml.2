Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1EKPjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:39:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54192 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1EKPj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:39:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: manual merge of the namespace tree with the m68k tree
References: <20110511140225.2c7e300f.sfr@canb.auug.org.au>
Date: Tue, 10 May 2011 21:17:31 -0700
In-Reply-To: <20110511140225.2c7e300f.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Wed, 11 May 2011 14:02:25 +1000")
Message-ID: <m1liydeuqs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18KTU9wrLrmEt41Q2UZiCz6ksHrckshGi8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> Today's linux-next merge of the namespace tree got a conflict in
> arch/m68k/kernel/entry_mm.S between commit 55e1af1ab184 ("m68k: Merge mmu
> and non-mmu versions of sys_call_table") from the m68k tree and commit
> e975ee91dcc1 ("ns: Wire up the setns system call") from the namespace
> tree.
>
> I just used the m68k version of that file and that should be all that is
> necessary.

Sounds good.  Gert asked me to check in that conflict (probably so
bisects will continue to work), and if the commit id is right it looks
like the m68k tree is seeing active development on that change right now.

Eric


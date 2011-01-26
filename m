Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1AZEaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:30:01 -0500
Received: from lo.gmane.org ([80.91.229.12]:43709 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1AZEaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:30:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [patch] UML kernels on {i386,x86_64} produce bad coredumps
Date: Wed, 26 Jan 2011 04:29:43 +0000 (UTC)
Message-ID: <iho7vn$kmn$2@dough.gmane.org>
References: <20110125231433.F2408190C3A@elbrus2.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Cc: user-mode-linux-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 15:14:33 -0800, Paul Pluzhnikov wrote:
...
> Examining the core shows that NT_PRSTATUS notes for all threads other
> than the one that crashed are zeroed out.
> 
> I believe this is happening because neither ELF_CORE_COPY_TASK_REGS nor
> task_pt_regs are defined under ARCH=um, and so elf_core_copy_task_regs()
> becomes a no-op.


I think this was missed due to some cleanups of the core elf
change, UML is one of the part overlooked by people. :-/

> 
> Attached patch fixes this for SUBARCH={x86_64,i386}.
> 
> Thanks,
> --
> Paul Pluzhnikov
> 
> P.S. Google has blanket FSF copyright assignment.
> 
> 
> Signed-off-by: Paul Pluzhnikov <ppluzhnikov@google.com>
> 

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.



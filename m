Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab2BBXld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:41:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44054 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2BBXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:41:32 -0500
MIME-Version: 1.0
In-Reply-To: <5afe2282e055f172906087538bdb1f3d.squirrel@webmail.greenhost.nl>
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
 <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl>
 <4F2A55B6.4030006@hitachi.com> <06cd49dcb5a124722e042c308144d5b7.squirrel@webmail.greenhost.nl>
 <20120202111007.GF889@n2100.arm.linux.org.uk> <5afe2282e055f172906087538bdb1f3d.squirrel@webmail.greenhost.nl>
From: Roland McGrath <mcgrathr@google.com>
Date: Thu, 2 Feb 2012 15:41:11 -0800
Message-ID: <CAB=4xhpP_=2UGnTi=max3rz7WSEbmfr14EgV_UA+VR9aby0kpA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
To: Indan Zupancic <indan@nul.nu>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Takuo Koguchi <takuo.koguchi.sw@hitachi.com>,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        jbaron@redhat.com, yrl.pp-manager.tt@hitachi.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 3:38 PM, Indan Zupancic <indan@nul.nu> wrote:
> It was my impression that thread_info->syscall is only set in the ptrace path.

The asm-generic/syscall.h kerneldoc says these functions should only be
used in the trace/audit path, not the fast path.  I honestly don't recall
any more why I made that a requirement of the interface, but some machines
having this sort of constraint was probably it.


Thanks,
Roland

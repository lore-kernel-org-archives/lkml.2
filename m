Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab2BJRjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:39:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2BJRjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:39:14 -0500
Date: Fri, 10 Feb 2012 18:32:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Chris Evans <scarybeasts@gmail.com>,
        Indan Zupancic <indan@nul.nu>
Subject: [PATCH 0/2] more tweaks (Was: ptrace tweaks)
Message-ID: <20120210173237.GF8908@redhat.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Denys Vlasenko wrote:
>
> This patch set fixes a minor bug in PTRACE_SETOPTIONS,
> slightly extends PTRACE_SEIZE (now it can take ptrace options),
> changes PTRACE_EVENT_STOP value,
> and enables PTRACE_SEIZE for non-development use.
>
> Ptrace git tree on kernel.org is not restored yet,
> so this patch set can't go through it.
>
> Andrew, please consider taking this patch set.

Yes, please...

I was going to send 1-4 to Linus a long ago, but I can't restore
my korg account.

Plus I have a couple of other minor ptrace changes, could you
take them too ?

Chris, iirc you suggested to add PTRACE_O_KILL_TRACEE_IF_DEBUGGER_DIES.
The necessary change is simple, please suggest the good name for the
new option ;)

Oleg.


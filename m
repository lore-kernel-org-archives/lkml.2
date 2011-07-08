Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1GHRQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1GHRQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:16:32 -0400
Date: Fri, 8 Jul 2011 19:13:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, indan@nul.nu, bdonlan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] PTRACE_SEIZE && fork() fixes
Message-ID: <20110708171320.GA26943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Oleg Nesterov wrote:
>
> Just to remind, tracehook_report_clone() shouldn't send SIGSTOP if
> the auto-attached tracee is PT_SEIZED.

I think it is the time to do this, everything else looks consistent.

The patches are simple but 3/3 needs the discussion and acks, this
API is new.

Oleg.


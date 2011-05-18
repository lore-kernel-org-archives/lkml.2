Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab1ERSwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:52:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549Ab1ERSwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:52:49 -0400
Date: Wed, 18 May 2011 20:50:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
	group stop notification, take#2
Message-ID: <20110518185050.GC1064@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> This patchset is on top of Oleg's ptrace branch[3] + prep patchset[2]
> and available in the following git branch.

IIUC 8/9 from prep patchset[2] needs the fix, do_wait()->restart_syscall()
is not right. Do you agree or I misunderstood the result of our discussion?

I'll continue the reading tomorrow.

Oleg.


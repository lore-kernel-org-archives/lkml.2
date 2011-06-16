Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1FPTqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab1FPTqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:46:46 -0400
Date: Thu, 16 Jun 2011 21:44:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
	group stop notification, take#5
Message-ID: <20110616194412.GA14786@redhat.com>
References: <1308043218-23619-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308043218-23619-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Tejun Heo wrote:
>
> This patchset contains the following five patches.
>
>   0001-job-control-introduce-JOBCTL_TRAP_STOP-and-use-it-fo.patch
>   0002-ptrace-implement-PTRACE_SEIZE.patch
>   0003-ptrace-implement-PTRACE_INTERRUPT.patch
>   0004-ptrace-implement-TRAP_NOTIFY-and-use-it-for-group-st.patch
>   0005-ptrace-implement-PTRACE_LISTEN.patch

Applied, thanks.

Oleg.


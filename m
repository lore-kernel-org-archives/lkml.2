Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab1E3Pnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:43:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab1E3Pnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:43:52 -0400
Date: Mon, 30 May 2011 17:42:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
	group stop notification, take#4
Message-ID: <20110530154211.GA11325@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 05/30, Tejun Heo wrote:
>
> * PTRACE_LISTEN added.  This puts tracee into quasi-active state where
>   wait(2) and sync ptrace requests fail and tracee is allowed to
>   re-trap into STOP to notify an async event.

Nice!

Personally, I think the whole series is fine. So far I only read it
inline (without applying). I'll try to read it carefully patch-by-patch,
it is always good to try to re-check the details, but I do not expect
I'll find something which should delay this series from merging into
ptrace tree.

Thanks Tejun ;)

Oleg.


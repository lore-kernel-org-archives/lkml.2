Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab2DPPjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab2DPPjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:39:16 -0400
Date: Mon, 16 Apr 2012 17:38:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidns: reboot_pid_ns: use SEND_SIG_FORCED instead of
	force_sig()
Message-ID: <20120416153843.GA9302@redhat.com>
References: <20120413004446.GA8376@redhat.com> <20120413182051.GA11149@sergelap> <20120413192455.GA24464@redhat.com> <20120416135931.GB4234@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416135931.GB4234@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Serge Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> >
> > Strange... I even tested this change, but only in the root namespace.
> > OK, thanks, I'll investigate. I hope you verified your kernel has
> > 629d362b commit ;)
>
> I took friday's HEAD of Linus tree.  All went fine.  Added this patch.
> The container can shutdown, but reboot causes shutdown.  Don't undersrtand
> why.

Heh. This looks "impossible". I'd like to understand the reason.
So, LINUX_REBOOT_CMD_RESTART results in WIFSIGNALED() == SIGINT?

OK, I'll try to test this patch in the non-root namespace.

Oleg.


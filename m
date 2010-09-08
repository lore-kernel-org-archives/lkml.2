Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0IHDAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 23:00:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45175 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0IHDAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 23:00:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/3] execve argument-copying fixes
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
In-Reply-To: <20100908023417.8B055401AF@magilla.sf.frob.com>
References: <20100830100616.78971400D9@magilla.sf.frob.com> <20100908023417.8B055401AF@magilla.sf.frob.com>
Message-Id: <20100908115948.C919.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Sep 2010 12:00:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is my take on parts of the execve large arguments copying issues
> that Kees posted about, and Brad and others have been discussing.
> I've only looked at the narrow area of the argument copying code
> itself.  I think these are good and necessary fixes.  But I'm not
> addressing the whole OOM killer/mm accounting issue, which also needs
> to be fixed (and I have the impression others are already looking into that).
> 
> The following changes since commit d56557af19867edb8c0e96f8e26399698a08857f:
> 
>   Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 (2010-09-07 16:00:17 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git topic/exec-fixes
> 
> Roland McGrath (3):
>       setup_arg_pages: diagnose excessive argument size
>       execve: improve interactivity with large arguments
>       execve: make responsive to SIGKILL with large arguments
> 
>  fs/exec.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)


All of changes looks nice to me :)
Thanks.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





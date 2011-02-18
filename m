Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1BRAWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:22:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942Ab1BRAWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:22:34 -0500
Date: Thu, 17 Feb 2011 16:21:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: userns: targeted capabilities v5
Message-Id: <20110217162146.1b8e45e0.akpm@linux-foundation.org>
In-Reply-To: <20110217150224.GA26334@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 15:02:24 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> Here is a repost of my previous user namespace patch, ported onto
> last night's git head.
> 
> It fixes several things I was doing wrong in the last (v4)
> posting, in particular:
> 
> 	1. don't set uts_ns->user_ns to current's when !CLONE_NEWUTS
> 	2. add a ipc_ns->user_ns which owns ipc_ns, and use that to
> 	   decide CAP_IPC_OWNER
> 	3. fix logic flaw caused by bad parantheses
> 	4. allow do_prlimit to current
> 	5. don't always give root full privs to init_user_ns
> 
> The expected course of development for user namespaces is laid out
> at https://wiki.ubuntu.com/UserNamespace.

Seems like a nice feature to be developing.

I worry about the maturity of it all at this stage.  How far along is
it *really*?

Is anyone else working with you on developing and reviewing this work?


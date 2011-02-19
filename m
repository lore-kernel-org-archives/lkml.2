Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1BSRuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 12:50:06 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:59056 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1BSRuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 12:50:03 -0500
Message-ID: <4D6002BB.30305@free.fr>
Date: Sat, 19 Feb 2011 18:49:47 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: xemul@parallels.com, containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 5/9] Allow ptrace from non-init user namespaces
References: <20110217150224.GA26334@mail.hallyn.com> <20110217150333.GE26395@mail.hallyn.com>
In-Reply-To: <20110217150333.GE26395@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 04:03 PM, Serge E. Hallyn wrote:
> ptrace is allowed to tasks in the same user namespace according to
> the usual rules (i.e. the same rules as for two tasks in the init
> user namespace).  ptrace is also allowed to a user namespace to
> which the current task the has CAP_SYS_PTRACE capability.
>
> Changelog:
> 	Dec 31: Address feedback by Eric:
> 		. Correct ptrace uid check
> 		. Rename may_ptrace_ns to ptrace_capable
> 		. Also fix the cap_ptrace checks.
> 	Jan  1: Use const cred struct
> 	Jan 11: use task_ns_capable() in place of ptrace_capable().
>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab1BSTWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 14:22:55 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:50788 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab1BSTWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:22:52 -0500
Message-ID: <4D60187F.7000102@free.fr>
Date: Sat, 19 Feb 2011 20:22:39 +0100
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
Subject: Re: [PATCH 9/9] userns: check user namespace for task->file uid	equivalence
 checks
References: <20110217150224.GA26334@mail.hallyn.com> <20110217150406.GI26395@mail.hallyn.com>
In-Reply-To: <20110217150406.GI26395@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 04:04 PM, Serge E. Hallyn wrote:
> Cheat for now and say all files belong to init_user_ns.  Next
> step will be to let superblocks belong to a user_ns, and derive
> inode_userns(inode) from inode->i_sb->s_user_ns.  Finally we'll
> introduce more flexible arrangements.
>
> Changelog:
> 	Feb 15: make is_owner_or_cap take const struct inode
>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>

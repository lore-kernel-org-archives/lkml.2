Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2KZQuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:50:21 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36542 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2KZQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:50:19 -0500
MIME-Version: 1.0
In-Reply-To: <20121127000800.660793d8fa6a28b79a61110b@canb.auug.org.au>
References: <20121127000800.660793d8fa6a28b79a61110b@canb.auug.org.au>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 26 Nov 2012 16:49:57 +0000
X-Google-Sender-Auth: fDLHnoyQ0hEUlgrd6eeCtdEtBto
Message-ID: <CAHkRjk4yn7sMM8hp6MG4uEF3UTMd2zuiosmMuLdSpgwNsw6F7A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with the signal tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2012 13:08, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the akpm tree got a conflict in
> arch/arm64/kernel/sys_compat.c arch/arm64/include/asm/unistd.h between
> commit 8709876911bd ("arm64: sanitize copy_thread(), switch to generic
> fork/vfork/clone") from the signal tree and commit "compat: generic
> compat_sys_sched_rr_get_interval() implementation" from the akpm tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks fine to me. Thanks.

-- 
Catalin

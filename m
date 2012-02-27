Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2B0F5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:57:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41962 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2B0F5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:57:30 -0500
Date: Mon, 27 Feb 2012 09:57:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-ID: <20120227055725.GC1904@moon>
References: <20120227165356.6119ac92eabd7052fc56c741@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227165356.6119ac92eabd7052fc56c741@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 04:53:56PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> arch/x86/syscalls/syscall_64.tbl between commit
> arch/x86/syscalls/syscall_64.tbl ("x32: Add x32 system calls to
> syscall/syscall_64.tbl") from the tip tree and commit "syscalls, x86: add
> __NR_kcmp syscall" from the akpm tree.
> 
> I fixed it up (see below) but did not know if this call should be marked
> "common".

Hi Stephen, letme fetch both trees to figure out what this new column means.
Will ping back shortly. Thanks!

	Cyrill

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2EGTU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:20:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab2EGTUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:20:54 -0400
Message-ID: <4FA821C2.4070107@suse.cz>
Date: Mon, 07 May 2012 21:25:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: manual merge of the tip tree with the kbuild tree
References: <20120507151054.3fa8df4599e81cc6ae87ca7a@canb.auug.org.au>
In-Reply-To: <20120507151054.3fa8df4599e81cc6ae87ca7a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 7.5.2012 07:10, Stephen Rothwell napsal(a):
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in Makefile
> between commit 1f2bfbd00e46 ("kbuild: link of vmlinux moved to a script")
> from the kbuild tree and commit 1dbdc6f177c6 ("kbuild/extable: Hook up
> sortextable into the build system") from the tip tree.
> 
> I used the Makefile bits from the kbuild tree and added the following
> patch as a merge fixup.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 7 May 2012 15:00:04 +1000
> Subject: [PATCH] kbuild: merge fix for sorting exceptions tables at build time

Looks correct, thanks.

Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2EUJNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:13:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35700 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab2EUJNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:13:08 -0400
Date: Mon, 21 May 2012 11:12:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20120521091257.GF31407@gmail.com>
References: <20120521185412.aca92107d0a8c4fdd8474e34@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521185412.aca92107d0a8c4fdd8474e34@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (i386 defconfig)
> failed like this:
> 
> Invalid absolute R_386_32 relocation: jiffies

Hm, that's our fault: seems like a linker bug fallout, one which 
we fixed in -tip.

> I am not sure what caused this (it may even been a bad merge 
> on my part).  I have left it broken for today.

While we've fixed this, to simplify merge window integration of 
linux-next I've excluded tip:x86/trampoline from the linux-next 
branch for now, so this build failure should go away tomorrow.

Sorry and thanks,

	Ingo

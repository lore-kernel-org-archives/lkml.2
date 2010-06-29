Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab0F2AWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:22:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1385 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0F2AWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:22:46 -0400
Subject: Re: [PATCH] arch/x86/kernel/cpu/mtrr/cleanup.c: Use ";" not "," to
 terminate statements
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100629001431.GC12255@elte.hu>
References: <1277768808.29157.280.camel@Joe-Laptop.home>
	 <20100629001431.GC12255@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jun 2010 17:22:42 -0700
Message-ID: <1277770962.29157.283.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 02:14 +0200, Ingo Molnar wrote:
> That file and this subsystem needs a lot more cleanups than just this. Would 
> you be willing to do them all, so that we can get over with the churn in a 
> single well-defined patch (or patches)?
> 
> I dont see much point in piecemail single-comma patches - i'd rather wait for 
> someone else who'd fix this and other details in one go.

I don't see significant style issues in mtrr

$ git ls-files arch/x86/kernel/cpu/mtrr/ | \
	xargs ./scripts/checkpatch.pl -f 

What do you think needs improving?git ls-files arch/x86/kernel/cpu/mtrr/
| \
	xargs ./scripts/checkpatch.pl -f 


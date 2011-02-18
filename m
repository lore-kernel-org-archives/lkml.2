Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab1BRTls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:41:48 -0500
Received: from mail.perches.com ([173.55.12.10]:3737 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab1BRTlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:41:47 -0500
Subject: Re: [tip:x86/debug] x86: Combine printk()s in show_regs_common()
From: Joe Perches <joe@perches.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-fd8fa4d3ddc4cc04ec8097e632b995d535c52beb@git.kernel.org>
References: <4D5D535A0200007800032730@vpn.id2.novell.com>
	 <tip-fd8fa4d3ddc4cc04ec8097e632b995d535c52beb@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 11:41:45 -0800
Message-ID: <1298058105.15565.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 10:40 +0000, tip-bot for Jan Beulich wrote:
> Commit-ID:  fd8fa4d3ddc4cc04ec8097e632b995d535c52beb
> Gitweb:     http://git.kernel.org/tip/fd8fa4d3ddc4cc04ec8097e632b995d535c52beb
> Author:     Jan Beulich <JBeulich@novell.com>
> AuthorDate: Thu, 17 Feb 2011 15:56:58 +0000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 18 Feb 2011 08:52:30 +0100
> 
> x86: Combine printk()s in show_regs_common()
> 
> Printing a single character alone when there's an immediately
> following printk() is pretty pointless (and wasteful).

Ingo, why did you choose to apply this patch instead of
the alternative one I posted on the same thread?

https://patchwork.kernel.org/patch/571641/



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab0LCA6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:58:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857Ab0LCA6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:58:15 -0500
Date: Thu, 2 Dec 2010 16:57:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 resend] OLPC: Add XO-1 suspend/resume support
Message-Id: <20101202165724.b852b82b.akpm@linux-foundation.org>
In-Reply-To: <20101118202837.B24899D401B@zog.reactivated.net>
References: <20101118202837.B24899D401B@zog.reactivated.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 20:28:37 +0000 (GMT)
Daniel Drake <dsd@laptop.org> wrote:

> Add code needed for basic suspend/resume of the XO-1 laptop.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/Kconfig                         |    2 +-
>  arch/x86/include/asm/olpc.h              |    9 ++-
>  arch/x86/platform/olpc/Makefile          |    2 +-
>  arch/x86/platform/olpc/olpc-xo1-wakeup.S |  132 ++++++++++++++++++++++++++++++
>  arch/x86/platform/olpc/olpc-xo1.c        |   79 ++++++++++++++++++

i386 allmodconfig:

make[3]: *** No rule to make target `arch/x86/platform/olpc/olpc-xo1-wakeup.c', 

I "fixed" that locally by making olpc depend on x86_64.

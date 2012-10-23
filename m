Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303Ab2JWURd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:17:33 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933563Ab2JWURa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:17:30 -0400
Date: Tue, 23 Oct 2012 22:17:25 +0200
From: Richard Weinberger <richard@nod.at>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 032/193] arch/x86/um: remove CONFIG_EXPERIMENTAL
Message-ID: <20121023221725.39b338d1@spider.haslach.nod.at>
In-Reply-To: <1351022666-6960-33-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-33-git-send-email-keescook@chromium.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, 23 Oct 2012 13:01:45 -0700
schrieb Kees Cook <keescook@chromium.org>:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Jeff Dike <jdike@addtoit.com>
> CC: Richard Weinberger <richard@nod.at>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Richard Weinberger <richard@nod.at>

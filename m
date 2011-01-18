Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1ARVpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:45:16 -0500
Received: from freeflow.nu ([178.79.134.28]:48656 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab1ARVpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:45:15 -0500
Subject: Re: [tip:x86/urgent] x86: Clear irqstack thread_info
From: Pekka Enberg <penberg@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, arjan@linux.intel.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, linux@merz-ka.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-7b698ea377e10b074ceef0d79218e6622d618421@git.kernel.org>
References: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
	 <tip-7b698ea377e10b074ceef0d79218e6622d618421@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 18 Jan 2011 23:45:10 +0200
Message-ID: <1295387110.19231.36.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 19:03 +0000, tip-bot for Brian Gerst wrote:
> Commit-ID:  7b698ea377e10b074ceef0d79218e6622d618421
> Gitweb:     http://git.kernel.org/tip/7b698ea377e10b074ceef0d79218e6622d618421
> Author:     Brian Gerst <brgerst@gmail.com>
> AuthorDate: Mon, 17 Jan 2011 07:32:10 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 18 Jan 2011 14:58:37 +0100
> 
> x86: Clear irqstack thread_info
> 
> Mathias Merz reported that v2.6.37 failed to boot on his
> system.
> 
> Make sure that the thread_info part of the irqstack is
> initialized to zeroes.
> 
> Reported-and-Tested-by: Matthias Merz <linux@merz-ka.de>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> Acked-by: Pekka Enberg <penberg@kernel.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> LKML-Reference: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

This needs to be tagged for -stable as well.


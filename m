Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0JUUq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:46:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077Ab0JUUq0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:46:26 -0400
MIME-Version: 1.0
In-Reply-To: <20101021134558.GA5859@elte.hu>
References: <20101021134558.GA5859@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Oct 2010 13:45:15 -0700
Message-ID: <AANLkTi=RKyHLNTq6iomZOXkc6Zw1j9iAgsq8388XmzwN@mail.gmail.com>
Subject: Re: [GIT PULL] x86/fpu for v2.6.37
To: Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 6:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest x86-fpu-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus

This conflicted with the CONFIG_AS_FXSAVEQ changes from the asm tree.

I fixed it up, but I did it only for  the fpu_fxsave() function. I
suspect that the CONFIG_AS_FXSAVEQ thing should be used for
fxsave_user() too.

                              Linus

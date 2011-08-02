Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1HBMvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 08:51:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34171 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1HBMvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 08:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110802124530.GA2543@albatros>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
Date: Tue, 2 Aug 2011 14:51:34 +0200
Message-ID: <CAOLZvyFSPxNC9Sr=0OE=2tLSaM_iX=2k0tokULfH7VkQdQPiMg@mail.gmail.com>
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Marc Zyngier <maz@misterjones.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        kernel-hardening@lists.openwall.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 2:45 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> Manuel, Richard, Marc - can you test this patch, please?

Works for me.

If it matters:
Tested-by: Manuel Lauss <manuel.lauss@googlemail.com>

Thanks!
        Manuel Lauss

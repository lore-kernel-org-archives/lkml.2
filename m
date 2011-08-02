Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1HBN3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:29:48 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:41668 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab1HBN3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:29:44 -0400
Date: Tue, 2 Aug 2011 14:29:25 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        kernel-hardening@lists.openwall.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
Message-ID: <20110802142925.4a42a603@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20110802124530.GA2543@albatros>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 109.234.204.184
X-SA-Exim-Rcpt-To: segoon@openwall.com, torvalds@linux-foundation.org, manuel.lauss@googlemail.com, linux-kernel@vger.kernel.org, richard@nod.at, akpm@linux-foundation.org, mingo@elte.hu, kernel-hardening@lists.openwall.com, paul.mckenney@linaro.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 16:45:30 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> Manuel, Richard, Marc - can you test this patch, please?

Works fine here (tested on an EB11MP).

FWIW: Tested-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
I'm the slime oozin' out from your TV set...

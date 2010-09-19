Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0ISRCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 13:02:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358Ab0ISRCO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 13:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <20100918155652.684071800@chello.nl>
References: <20100918155326.478277313@chello.nl> <20100918155652.684071800@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Sep 2010 10:01:12 -0700
Message-ID: <AANLkTikkVZEGS=1_qbwPoG47twdbzrgWa85NEVD3TxMK@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm: stack based kmap_atomic
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <rmk@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 8:53 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>  usr/src/linux-2.6/drivers/gpu/drm/nouveau/nouveau_bios.c | 6832 ---------------
>  29 files changed, 361 insertions(+), 7195 deletions(-)

What's that odd 'usr/src/linux-2.6' file that you have and removed?

You're using some seriously broken SCM there.

                  Linus

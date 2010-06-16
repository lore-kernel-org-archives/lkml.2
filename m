Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab0FPGL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:11:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756024Ab0FPGL1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
Date: Tue, 15 Jun 2010 23:10:45 -0700
Message-ID: <AANLkTinhO5sFs4YRP3nraC_ldZ8ZgzJBOQYYv9jLd_Dw@mail.gmail.com>
Subject: Re: [PATCH -v18 00/37] Use lmb with x86
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 15, 2010, Yinghai Lu <yinghai@kernel.org> wrote:
>
>  46 files changed, 1476 insertions(+), 1282 deletions(-)

So what was the advantage again? It's adding more lines than it
removes. Wasn't the point to simplify things, not make them bigger?

      Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1FNRaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:30:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768Ab1FNRaV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Jun 2011 10:29:30 -0700
Message-ID: <BANLkTintgwYuUcMjY91gGk8G07wmWyQ1sw@mail.gmail.com>
Subject: Re: [PATCH 0/12] tmpfs: convert from old swap vector to radix tree
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Robin Holt <holt@sgi.com>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 3:40 AM, Hugh Dickins <hughd@google.com> wrote:
>
> thus saving memory, and simplifying its code and locking.
>
>  13 files changed, 669 insertions(+), 1144 deletions(-)

Hey, I can Ack this just based on the fact that for once "simplifying
its code" clearly also removes code. Yay! Too many times the code
becomes "simpler" but bigger.

                       Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab2EUCfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 22:35:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46796 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab2EUCfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 22:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120521120526.fcd34b38fa4d21fdfd28728b@canb.auug.org.au>
References: <1337562868-9887-1-git-send-email-roland@kernel.org> <20120521120526.fcd34b38fa4d21fdfd28728b@canb.auug.org.au>
From: Roland Dreier <roland@kernel.org>
Date: Sun, 20 May 2012 19:35:30 -0700
X-Google-Sender-Auth: Z_JX6Y0qaJo44Pv-k5OBiYyznPk
Message-ID: <CAG4TOxPpNxFvR_8GkAJ6erDBHBUQzQe3ReFKnK6gBkfAYhRMeQ@mail.gmail.com>
Subject: Re: [GIT PULL] please pull infiniband.git
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 7:05 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>> Vipul Pandya (10):
>>       cxgb4: Detect DB FULL events and notify RDMA ULD
>>       cxgb4: Common platform specific changes for DB Drop Recovery
>>       cxgb4: DB Drop Recovery for RDMA and LLD queues
>>       RDMA/cxgb4: Add debugfs RDMA memory stats
>>       RDMA/cxgb4: Add DB Overflow Avoidance
>>       RDMA/cxgb4: Disable interrupts in c4iw_ev_dispatch()
>>       RDMA/cxgb4: DB Drop Recovery for RDMA and LLD queues
>>       RDMA/cxgb4: Use vmalloc() for debugfs QP dump

> This commit breaks (at least) powerpc builds and has not bee in linux-next
> before today.

Sorry about that. Which commit in particular?  The vmalloc one?
What's the error?

(I did add this patchset to my for-next branch on Friday at the
latest, but I understand if you didn't do a linux-next build over the
past 48 weekend hours :)

 - R.

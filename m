Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1FGXst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:48:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab1FGXss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:48:48 -0400
Date: Tue, 7 Jun 2011 16:48:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arun Sharma <asharma@fb.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/2] atomic: move atomic_add_unless to generic code
Message-Id: <20110607164835.86fa15f4.akpm@linux-foundation.org>
In-Reply-To: <4DE7C6FF.70108@fb.com>
References: <1306869046-20172-1-git-send-email-asharma@fb.com>
	<1306869046-20172-2-git-send-email-asharma@fb.com>
	<BANLkTi=Tg=t5LrnvR2Sn08K0Ktm8ZKNCCA@mail.gmail.com>
	<4DE55AE9.90505@fb.com>
	<BANLkTi=nKqwFKt8boNHQ=imgEz0fdyGCqw@mail.gmail.com>
	<4DE7C6FF.70108@fb.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jun 2011 10:23:11 -0700
Arun Sharma <asharma@fb.com> wrote:

> On 6/2/11 7:53 AM, Mike Frysinger wrote:
> 
> >> The idea is to move atomic_add_unless_return() into linux/atomic.h
> >
> > my point is that that patchset doesnt seem to exist yet, and it'd
> > probably make sense to have it ready and part of this series before
> > attempting to push this.
> 
> I posted the patch a couple of days ago:
> 
> 1306889876-5327-1-git-send-email-asharma@fb.com
> http://thread.gmane.org/gmane.linux.kernel/1148420
> 

This is way too hard.  Please send the *entire* patchset with full
descriptions in the changelogs.  Not referring to kooky MessageID's, no
links to archives which might be removed.  Aim to have a complete,
well-presented patchset which our children can as-easily-as-possible
understand when they read the git commit logs in 2042.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1BIJ2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:28:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32960 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1BIJ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:28:37 -0500
Subject: Re: Misc sd_idle related fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@gmail.com>
In-Reply-To: <1297188819-19999-1-git-send-email-venki@google.com>
References: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
	 <1297188819-19999-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 10:29:38 +0100
Message-ID: <1297243778.13327.143.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 10:13 -0800, Venkatesh Pallipadi wrote:
> Here are the 3 sd_idle related changes I tested with, for reference. Among
> the three, the third patch is the one that helps us in reducing idle cycles
> with one of our workloads and thus improves the latency response.

Have you tried what happens if you simply rip all that SMT stuff out and
simplify the code? Afaict much of the capacity stuff we have should have
a similar effect and is less confusing, no?


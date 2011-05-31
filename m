Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab1EaRFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:05:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722Ab1EaRFo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:05:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110531162726.GA15162@elte.hu>
References: <20110531162726.GA15162@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Jun 2011 02:05:21 +0900
Message-ID: <BANLkTi=aWc2c18OohJVmVn_aniyxDKO9Rw@mail.gmail.com>
Subject: Re: [GIT PULL] RCU fix
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 1:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest core-urgent-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-urgent-for-linus

So remind me again why RCU switched to the stupid threads? It caused
problems for rcutiny, it now causes silly problems for rcutree. Why do
it? It's just extra complexity and no real advantage afaik.

                 Linus

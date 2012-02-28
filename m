Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965768Ab2B1V1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:27:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145Ab2B1V1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:27:20 -0500
Date: Tue, 28 Feb 2012 13:27:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
Message-Id: <20120228132719.f375071a.akpm@linux-foundation.org>
In-Reply-To: <20120228084359.GJ21106@elte.hu>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
	<20120227155338.7b5110cd.akpm@linux-foundation.org>
	<20120228084359.GJ21106@elte.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 09:43:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> This patch should also probably go upstream through the 
> locking/lockdep tree? Mind sending it us once you think it's 
> ready?

Oh goody, that means you own
http://marc.info/?l=linux-kernel&m=131419353511653&w=2.

I do think the brlock code is sick, but Nick has turned into an ex-Nick
and nobody works on it.


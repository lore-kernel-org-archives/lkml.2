Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab1CCLYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:24:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461Ab1CCLYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:24:32 -0500
Date: Thu, 3 Mar 2011 03:24:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
        Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: work around old gas bug (try 2)
Message-Id: <20110303032419.954dab8e.akpm@linux-foundation.org>
In-Reply-To: <20110303105755.GA24181@elte.hu>
References: <4D6F81B10200007800034B0B@vpn.id2.novell.com>
	<20110303105755.GA24181@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 11:57:55 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jan Beulich <JBeulich@novell.com> wrote:
> 
> > Add extra parentheses around a couple of definitions introduced by
> > "x86: Cleanup vector usage" and used in assembly macro arguments, and
> > remove spaces. Without that old (2.16.1) gas would see more macro
> > arguments than were actually specified.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Shaohua Li <shaohua.li@intel.com>
> 
> Wondering, have you managed to test this with 2.16, or should i wait for akpm's 
> testing before applying it?
> 

arch/x86/kernel/entry_64.S compiles successfully with that patch.

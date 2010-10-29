Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393Ab0J2MHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:07:51 -0400
Received: from www.tglx.de ([62.245.132.106]:38463 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896Ab0J2MHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:07:49 -0400
Date: Fri, 29 Oct 2010 14:07:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x8: Move olpc to platform
In-Reply-To: <4CCA685B.1050800@kernel.org>
Message-ID: <alpine.LFD.2.00.1010291322320.2692@localhost6.localdomain6>
References: <tip-dd191daf06233644a8c5011511e91beb3c598050@git.kernel.org> <4CCA685B.1050800@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010, Yinghai Lu wrote:

> On 10/27/2010 05:48 AM, tip-bot for Thomas Gleixner wrote:
> > Commit-ID:  dd191daf06233644a8c5011511e91beb3c598050
> > Gitweb:     http://git.kernel.org/tip/dd191daf06233644a8c5011511e91beb3c598050
> > Author:     Thomas Gleixner <tglx@linutronix.de>
> > AuthorDate: Sat, 23 Oct 2010 11:28:42 +0200
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Wed, 27 Oct 2010 14:30:02 +0200
> > 
> > x8: Move olpc to platform
> 
> x8?

Ingo fixed that already :)
 
> BTW, are you going to move related code in arch/x86/kernel/apic and
> arch/x86/pci into arch/x86/platform/xxx?

Not sure about those.

Thanks,

	tglx

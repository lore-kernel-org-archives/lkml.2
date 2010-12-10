Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab0LJBTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:19:18 -0500
Received: from www.tglx.de ([62.245.132.106]:35525 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451Ab0LJBTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:19:17 -0500
Date: Fri, 10 Dec 2010 02:18:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arthur Kepner <akepner@sgi.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH RESEND] x86/irq: assign vectors from numa_node
In-Reply-To: <20101209224830.GH20481@sgi.com>
Message-ID: <alpine.LFD.2.00.1012100214020.2653@localhost6.localdomain6>
References: <20101209224830.GH20481@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Arthur Kepner wrote:

It's in my list of patches to go through already. 
 
> (Resending with expanded cc list.)

FYI, you expanded the cc list just in your mail client. In reality
exactly by zero. x86@kernel.org is a mail exploder to hpa, mingo and
tglx :)

Thanks,

	tglx

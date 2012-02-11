Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2BKOuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 09:50:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48094 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab2BKOuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 09:50:11 -0500
Date: Sat, 11 Feb 2012 15:50:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, soc: Fix fallout from the previous changes
Message-ID: <20120211145003.GC497@elte.hu>
References: <20120209141517.26563.45774.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209141517.26563.45774.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> The PCI fixups get executed based upon whether they are linked in. We need
> to avoid executing them if we boot a dual SoC/PC type kernel on a PC class
> system.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  arch/x86/pci/mrst.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)

This would be for Jesse's PCI tree I think.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab0EIKsD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 06:48:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0EIKsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 06:48:00 -0400
Date: Sun, 9 May 2010 12:47:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       dtor@vmware.com, tglx@linutronix.de, akataria@vmware.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] Modify the VMware balloon driver for the new
 x86_hyper API
Message-ID: <20100509104749.GA29586@elte.hu>
References: <4BE49778.6060800@zytor.com>
 <tip-a10a569806e43b9be5fce60b21f836b50b1010e4@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-a10a569806e43b9be5fce60b21f836b50b1010e4@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for H. Peter Anvin <hpa@zytor.com> wrote:

> Commit-ID:  a10a569806e43b9be5fce60b21f836b50b1010e4
> Gitweb:     http://git.kernel.org/tip/a10a569806e43b9be5fce60b21f836b50b1010e4
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Sun, 9 May 2010 01:13:42 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Sun, 9 May 2010 01:13:42 -0700
> 
> Modify the VMware balloon driver for the new x86_hyper API
> 
> Modify the VMware balloon driver to match the new x86_hyper API.

FYI, this is still not enough - now the allmodconfig build fails with:

ERROR: "x86_hyper" [drivers/misc/vmware_balloon.ko] undefined!

	Ingo

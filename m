Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0JNGGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:06:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab0JNGG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:06:28 -0400
Date: Thu, 14 Oct 2010 08:06:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com, Yinghai Lu <yinghai@kernel.org>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] x86-64: Only set max_pfn_mapped to 512 MiB
 if we enter via head_64.S
Message-ID: <20101014060617.GA4751@elte.hu>
References: <4CB641F7.9040103@goop.org>
 <tip-859ee4f57fb4e91de8439496f62eb996f4a28ca8@git.kernel.org>
 <20101014055714.GA3329@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014055714.GA3329@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * tip-bot for Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Commit-ID:  859ee4f57fb4e91de8439496f62eb996f4a28ca8
> > Gitweb:     http://git.kernel.org/tip/859ee4f57fb4e91de8439496f62eb996f4a28ca8
> > Author:     Jeremy Fitzhardinge <jeremy@goop.org>
> > AuthorDate: Wed, 13 Oct 2010 16:34:15 -0700
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Wed, 13 Oct 2010 17:09:59 -0700
> > 
> > x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S
> > 
> > head_64.S maps up to 512 MiB, but that is not necessarity true for
> > other entry paths, such as Xen.
> 
> These two commits are a boot crasher on x86 defconfig (64-bit):

Caused by this one of the two:

  859ee4f: x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0EKXFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:05:45 -0400
Received: from ozlabs.org ([203.10.76.45]:37770 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab0EKXFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:05:43 -0400
Date: Wed, 12 May 2010 09:05:42 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       benh@kernel.crashing.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [tip:core/locking] mutex: Fix optimistic spinning vs. BKL
Message-ID: <20100511230542.GU12389@ozlabs.org>
Mail-Followup-To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
	hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
	benh@kernel.crashing.org, stable@kernel.org, tglx@linutronix.de,
	mingo@elte.hu
References: <20100507042010.GR12389@ozlabs.org>
 <tip-227945799cc10d77c6ef812f3eb8a61a78689454@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-227945799cc10d77c6ef812f3eb8a61a78689454@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 03:43:01PM +0000, tip-bot for Tony Breeds wrote:
> Commit-ID:  227945799cc10d77c6ef812f3eb8a61a78689454
> Gitweb:     http://git.kernel.org/tip/227945799cc10d77c6ef812f3eb8a61a78689454
> Author:     Tony Breeds <tony@bakeyournoodle.com>

For the record this is Ben's patch not mine, I just used time_before() to
address feedback.

Thanks for taking it though.

Yours Tony

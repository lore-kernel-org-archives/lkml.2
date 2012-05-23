Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325Ab2EWQKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:10:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38115 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2EWQKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:10:42 -0400
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        frank.arnold@amd.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        borislav.petkov@amd.com
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
	 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 18:10:29 +0200
Message-ID: <1337789429.9783.16.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 09:07 -0700, tip-bot for Borislav Petkov wrote:
> +#define BIT_64(n)                      (U64_C(1) << (n))

Because writing 1ULL << n is too much work? 




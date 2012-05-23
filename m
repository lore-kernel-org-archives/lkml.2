Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab2EWQy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:54:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760506Ab2EWQyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:54:55 -0400
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <1337790571.9783.28.camel@laptop>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
	 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
	 <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com>
	 <20120523161932.GN14757@aftab.osrc.amd.com>
	 <1337790571.9783.28.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 18:54:43 +0200
Message-ID: <1337792083.9783.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 18:29 +0200, Peter Zijlstra wrote:
> If I remember my type rules correctly you'll get something like that
> with:
> 
> #define BIT(n)  ({ typeof(n) __n = (n); (__n < 32) ? (1UL << __n) : (1ULL << __n); })

OK, that doesn't work. Memory played tricks on me. Now I'll keep
wondering what was special about ?: and how I've seen it abused.


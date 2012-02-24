Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2BXSPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:15:52 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42304 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755848Ab2BXSPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:15:51 -0500
Message-ID: <1330107349.18464.9.camel@joe2Laptop>
Subject: Re: [PATCH] MAINTAINERS: drop me from PA-RISC maintenance
From: Joe Perches <joe@perches.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Feb 2012 10:15:49 -0800
In-Reply-To: <20120224153614.GA29597@redacted.bos.redhat.com>
References: <20120224153614.GA29597@redacted.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 10:36 -0500, Kyle McMartin wrote:
> I don't even live in the same country as any of my PA-RISC hardware
> these days, so the odds of me touching the code are pretty low.
> (Also re-order things to ensure jejb gets CC'd since he's been the
>  primary maintainer for the last few years.)
> 
> Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

Hi Kyle.

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -3047,7 +3046,6 @@ F:	drivers/hwspinlock/hwspinlock_*
>  F:	include/linux/hwspinlock.h
>  
>  HARMONY SOUND DRIVER
> -M:	Kyle McMartin <kyle@mcmartin.ca>
>  L:	linux-parisc@vger.kernel.org
>  S:	Maintained
>  F:	sound/parisc/harmony.*

I'll still assert that entries with no
actual person as a contact are unmaintained
and should be marked at best "odd fixes"
and more likely marked "orphan".



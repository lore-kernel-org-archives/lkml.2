Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1BUKnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:43:35 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:43040 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1BUKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:43:34 -0500
Date: Mon, 21 Feb 2011 21:43:27 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: update interface comments to reflect reality
Message-ID: <20110221104326.GA28805@gondor.apana.org.au>
References: <20110217222336.GF2621@redhat.com> <1297981754.11705.9.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297981754.11705.9.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 04:29:14PM -0600, Matt Mackall wrote:
> On Thu, 2011-02-17 at 17:23 -0500, Jarod Wilson wrote:
> > At present, the comment header in random.c makes no mention of
> > add_disk_randomness, and instead, suggests that disk activity adds to the
> > random pool by way of add_interrupt_randomness, which appears to not have
> > been the case since sometime prior to the existence of git, and even prior
> > to bitkeeper. Didn't look any further back. At least, as far as I can
> > tell, there are no storage drivers setting IRQF_SAMPLE_RANDOM, which is a
> > requirement for add_interrupt_randomness to trigger, so the only way for a
> > disk to contribute entropy is by way of add_disk_randomness. Update
> > comments accordingly, complete with special mention about solid state
> > drives being a crappy source of entropy (see e2e1a148bc for reference).
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> Sure. Herbert, let's route this through your crypto tree.
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

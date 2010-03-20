Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0CTOHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:07:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49709 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0CTOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:07:14 -0400
Date: Sat, 20 Mar 2010 15:07:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       apw@canonical.com
Subject: Re: [PATCH] checkpatch: Add check for too short Kconfig descriptions
Message-ID: <20100320140710.GS20695@one.firstfloor.org>
References: <20100320023216.GA917@basil.fritz.box> <4BA4CE32.1020207@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA4CE32.1020207@imap.cc>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 02:31:30PM +0100, Tilman Schmidt wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Am 2010-03-20 03:32 schrieb Andi Kleen:
> >     I've seen various new Kconfigs with rather unhelpful one liner
> >     descriptions. Add a Kconfig warning for a minimum length of the
> >     Kconfig help section.
> 
> I don't think helpfulness can be enforced via line count.

The warning merely is intended to get people to think
about that. Yes it cannot enforce it directly.

> A one-liner can be quite sufficient (eg. CRYPTO_MD4).

I don't think that one liner is sufficient. Consider the stand point
of someone who doesn't know anything of cryptography. They will
need at least one or two sentences to decided if they need
that option not.

Yes it will likely lead to some duplicate descriptions, but that's not
a problem. In fact it's a feature because it makes the job of
the person setting that option easier.

> OTOH more lines can still leave important questions unanswered (eg.
> CRYPTO_SALSA20_586 whose help text is identical to that of
> CRYPTO_SALSA20, leaving you wondering when to choose one over the other).

Yes it's not a perfect measure and can be circumvented. But hopefully
most users would not.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

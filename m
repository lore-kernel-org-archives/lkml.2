Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1ATLfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:35:17 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:52814 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1ATLfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:35:14 -0500
Date: Thu, 20 Jan 2011 22:35:04 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Dont kick-off hangcheck after a DRI interrupt
Message-ID: <20110120113504.GA4737@gondor.apana.org.au>
References: <20110120070508.GA2345@gondor.apana.org.au> <1295517361-15825-1-git-send-email-chris@chris-wilson.co.uk> <20110120101010.GA4299@gondor.apana.org.au> <0d30dc$kqbkiv@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d30dc$kqbkiv@orsmga001.jf.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 11:00:25AM +0000, Chris Wilson wrote:
>
> Except that i915_hangcheck_elapsed should not be called from DRI code
> paths, the whole error recovery code only works with GEM (we can't recover
> the hardware if it is being poked directly by "userspace").

Oh I see what you mean.  Yes that should do the trick.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

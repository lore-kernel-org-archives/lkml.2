Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0G1QCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:02:32 -0400
Received: from waste.org ([173.11.57.241]:58703 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0G1QCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:02:31 -0400
Subject: Re: [PATCH] random: reorder struct entropy_store to remove padding
 on 64bits
From: Matt Mackall <mpm@selenic.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1280309521.2029.5.camel@castor.rsk>
References: <1280309521.2029.5.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 11:02:28 -0500
Message-ID: <1280332948.11415.705.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 10:32 +0100, Richard Kennedy wrote:
> Re-order structure entropy_store to remove 8 bytes of padding on
> 64 bit builds, so shrinking this structure from 72 to 64 bytes
> and allowing it to fit into one cache line.

I have a vague memory that we reordered things so that the r/w bits
would be on a separate cache line than the r/o bits. But as we never
added the alignment primitives to actually enforce that, I guess it
doesn't matter much. 

> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Signed-off-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.



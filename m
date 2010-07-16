Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab0GPU6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:58:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41039 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136Ab0GPU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:58:32 -0400
Date: Fri, 16 Jul 2010 21:58:13 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20100716205812.GA14297@flint.arm.linux.org.uk>
References: <20100716171124.064cf319.sfr@canb.auug.org.au> <4C40A766.6060309@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C40A766.6060309@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 11:39:34AM -0700, Yinghai Lu wrote:
> On 07/16/2010 12:11 AM, Stephen Rothwell wrote:
> > Hi Russell,
> > 
> > After merging the final tree, today's linux-next build (most, if not all
> > arm configs) failed (not unexpectedly) due to the lmb -> memblock rename
> > (commit 95f72d1ed41a66f1c1c29c24d479de81a0bea36f "lmb: rename to
> > memblock").
> > 
> > See http://kisskb.ellerman.id.au/kisskb/branch/9/
> 
> You or Russell may need to run the scripts in that patch

I've already fixed it up.  I'm guessing that we'll see the results
sometime on Monday.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

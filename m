Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269Ab0HFLjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:39:39 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:59165 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab0HFLjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:39:37 -0400
X-Greylist: delayed 1552 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2010 07:39:37 EDT
Date: Fri, 6 Aug 2010 15:13:39 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Olivier Galibert <galibert@pobox.com>, kyle@moffetthome.net,
        torvalds@linux-foundation.org, herbert@gondor.hengli.com.au,
        dhowells@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr problem
Message-ID: <20100806111339.GA8259@ioremap.net>
References: <20100806080642.GA4642@dspnet.fr> <20100806083900.GA25385@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806083900.GA25385@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 04:39:00PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> So you'd rather have a box that doesn't boot rather than one
> that automatically falls back to software crypto allowing you
> to diagnose and report the problem.

What about kernel boot parameter to test hardware accelerators or not?

-- 
	Evgeniy Polyakov

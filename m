Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2G3H4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 03:56:51 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:48041 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753714Ab2G3H4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 03:56:49 -0400
Date: Mon, 30 Jul 2012 15:56:28 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kent Yoder <key@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/4] powerpc/crypto: IBM Power7+ in-Nest compression
 support
Message-ID: <20120730075628.GE5515@gondor.apana.org.au>
References: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 09:42:37AM -0500, Seth Jennings wrote:
> This is a continuation of support for the Power7+ in-Nest
> hardware accelerator.
> 
> https://lkml.org/lkml/2012/4/12/223
> 
> This patchset adds the hardware driver and the cryptographic
> driver for hardware accelerated compression, which uses a
> hardware-optimized algorithm named 842.
> 
> The hardware driver has limits on generic compression and is
> geared toward compressing units that are of PAGE_SIZE for
> in-kernel memory compression.
> 
> Based on linux-next (20120717)
> 
> Seth Jennings (4):

All applied.  Thanks Seth.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab0JKEKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 00:10:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64598 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab0JKEKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 00:10:13 -0400
Date: Sun, 10 Oct 2010 22:10:10 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] sparc: make drivers/of/pdt.c no longer sparc-only
Message-ID: <20101011041010.GB23588@angua.secretlab.ca>
References: <20101010014358.30cb74b5@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010014358.30cb74b5@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 01:43:58AM -0700, Andres Salomon wrote:
> 
> Clean up pdt.c:
>  - make build dependent upon config OF_PROMTREE
>  - #ifdef out the sparc-specific stuff
>  - create pdt-specific header
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Applied, thanks.  Since the difference between this version and the
last is trivial, I've carried over davem's acked-by lines on the first
3 patches.

Dave, let me know if you've got any issues with this and I'll drop
them from my tree.

g.


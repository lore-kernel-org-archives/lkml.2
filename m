Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab0HEPGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:06:45 -0400
Received: from mail.lixom.net ([70.86.134.90]:53785 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933539Ab0HEPGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:06:40 -0400
Date: Thu, 5 Aug 2010 10:06:40 -0500
From: Olof Johansson <olof@lixom.net>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: R_ARM_REL32 relocation support
Message-ID: <20100805150640.GA25061@lixom.net>
References: <1280993763-15254-1-git-send-email-olof@lixom.net> <19546.31437.994840.466509@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19546.31437.994840.466509@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:48:13AM +0200, Mikael Pettersson wrote:
> Olof Johansson writes:
>  > commit d0679c730395d0bde9a46939e7ba255b4ba7dd7c moved -fno-dwarf2-cfi-asm to be
>  > powerpc-only, causing R_ARM_REL32 to be used with some toolchains on ARM.
>  > 
>  > Implement support for it to make modules work with more toolchains.
>  > 
>  > Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> Michal Marek's patch(*) to use -fno-dwarf2-cfi-asm already exists
> and is IMO the correct solution in that it addresses the cause
> of the problem rather than its symptoms.
> 
> NAK from me for now.
> 
> (*) http://lkml.org/lkml/2010/7/26/154

Sigh. I searched the list for related patches and didn't see any. Sorry for the duplicate.


-Olof


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab1KVVFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:05:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64511 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab1KVVFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:05:46 -0500
Subject: Re: [PATCH 2/3] mtd/nand : set Nand flash page address to FBAR and
 FPAR correctly
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: LiuShuo <b35362@freescale.com>
Cc: dwmw2@infradead.org, Artem.Bityutskiy@nokia.com,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com, scottwood@freescale.com,
        Jerry Huang <Chang-Ming.Huang@freescale.com>,
        Tang Yuantian <b29983@freescale.com>
Date: Tue, 22 Nov 2011 23:05:38 +0200
In-Reply-To: <4EC5BE16.9080205@freescale.com>
References: <1321349355-1639-1-git-send-email-b35362@freescale.com>
		 <1321349355-1639-2-git-send-email-b35362@freescale.com>
	 <1321568016.2272.29.camel@koala> <4EC5BE16.9080205@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321995943.2222.3.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 10:08 +0800, LiuShuo wrote:
> Ok and I want to add another patch before 3/3.
> 
> -LiuShuo
> > On Tue, 2011-11-15 at 17:29 +0800, b35362@freescale.com wrote:
> >> From: Liu Shuo<b35362@freescale.com>
> >>
> >> If we use the Nand flash chip whose number of pages in a block is greater
> >> than 64(for large page), we must treat the low bit of FBAR as being the
> >> high bit of the page address due to the limitation of FCM, it simply uses
> >> the low 6-bits (for large page) of the combined block/page address as the
> >> FPAR component, rather than considering the actual block size.
> > Looks like this patch depends on the previous white-space clean-up patch
> > - could you please refactor it (and 3/3 too) and resend?
> Ok and I am going to add another new patch before 3/3.

Sure, send 3/3 as well because this one depends on the cleanup patch, so
cannot be applied independently.

Artem.


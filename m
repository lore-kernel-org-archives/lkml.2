Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1LLVEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:04:36 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43311 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042Ab1LLVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:04:35 -0500
Subject: Re: [PATCH 1/2] mtd/nand : set Nand flash page address to FBAR and
 FPAR correctly
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: shuo.liu@freescale.com
Cc: dwmw2@infradead.org, Artem.Bityutskiy@nokia.com, scottwood@freescale.com,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com
Date: Mon, 12 Dec 2011 23:04:25 +0200
In-Reply-To: <1323423775-26951-1-git-send-email-shuo.liu@freescale.com>
References: <1323423775-26951-1-git-send-email-shuo.liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323723871.2297.9.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 17:42 +0800, shuo.liu@freescale.com wrote:
> From: Liu Shuo <b35362@freescale.com>
> 
> If we use the Nand flash chip whose number of pages in a block is greater
> than 64(for large page), we must treat the low bit of FBAR as being the
> high bit of the page address due to the limitation of FCM, it simply uses
> the low 6-bits (for large page) of the combined block/page address as the
> FPAR component, rather than considering the actual block size.

Pushed this one to l2-mtd-2.6.git, thanks!

Artem.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab1LFLtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:49:25 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36252 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933192Ab1LFLtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:49:24 -0500
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: shuo.liu@freescale.com
Cc: dwmw2@infradead.org, Artem.Bityutskiy@nokia.com, scottwood@freescale.com,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com
Date: Tue, 06 Dec 2011 13:49:15 +0200
In-Reply-To: <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	 <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323172160.2163.2.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-04 at 12:31 +0800, shuo.liu@freescale.com wrote:
> From: Liu Shuo <shuo.liu@freescale.com>
> 
> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
> to support the Nand flash chip whose page size is larger than 2K bytes,
> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
> them to a large buffer.
> 
> Signed-off-by: Liu Shuo <shuo.liu@freescale.com>

This patch does not apply on top of my l2-mtd-2.6.git tree. Could you
please send a patch that applies cleanly?

Thanks!


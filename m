Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab0LNMKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:10:01 -0500
Received: from 64.mail-out.ovh.net ([91.121.185.65]:50161 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756407Ab0LNMJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:09:59 -0500
Date: Tue, 14 Dec 2010 13:05:16 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, avictor.za@gmail.com
Subject: Re: [PATCH] dmaengine: at_hdmac: fix buffer transfer size
 specification
Message-ID: <20101214120516.GN19897@game.jcrosoft.org>
References: <1292244521-20756-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292244521-20756-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6814790662829878124
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:48 Mon 13 Dec     , Nicolas Ferre wrote:
> Buffer transfer size is the number of transfers to be performed in
> relation with the width of the _source_ interface.
> So in the DMA_FROM_DEVICE case, it should be the register width that
> should be taken into account.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.

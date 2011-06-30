Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab1F3Bhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:37:32 -0400
Received: from 21.98.mail-out.ovh.net ([178.32.119.154]:59557 "EHLO
	98.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753661Ab1F3Bh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:37:26 -0400
X-Greylist: delayed 119400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 21:37:26 EDT
Date: Thu, 30 Jun 2011 03:06:28 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        hong.xu@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MTD: atmel_nand: fix wrong use of 0 as NULL
Message-ID: <20110630010628.GI17355@game.jcrosoft.org>
References: <1309365676-19210-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309365676-19210-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14959550587370187628
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:41 Wed 29 Jun     , Nicolas Ferre wrote:
> Fixing this error:
> atmel_nand.c:718:20: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.

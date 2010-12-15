Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0LOBeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:34:23 -0500
Received: from 64.mail-out.ovh.net ([91.121.185.65]:39947 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752060Ab0LOBeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:34:21 -0500
Date: Wed, 15 Dec 2010 02:29:36 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
        Rob Emanuele <rje@crystalfontz.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] USB: atmel_usba_udc: fix freeing irq in
 usba_udc_remove()
Message-ID: <20101215012936.GR19897@game.jcrosoft.org>
References: <636999.52551.qm@web180309.mail.gq1.yahoo.com>
 <1292349630-3610-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292349630-3610-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1952310440136059756
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:00 Tue 14 Dec     , Nicolas Ferre wrote:
> From: Rob Emanuele <rje@crystalfontz.com>
> 
> Add a free_irq() call on vbus gpio when we remove udc so that the
> vbus irq is properly released.
> 
> Signed-off-by: Rob Emanuele <rje@crystalfontz.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.

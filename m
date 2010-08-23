Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0HWDDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 23:03:44 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:59424 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753083Ab0HWDDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 23:03:36 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Aug 2010 23:03:36 EDT
Date: Mon, 23 Aug 2010 04:56:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: siccegge@cs.fau.de, costa.antonior@gmail.com,
        vamos@i4.informatik.uni-erlangen.de, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] AT91: Correct configuration define value
Message-ID: <20100823025645.GQ8693@game.jcrosoft.org>
References: <4c6fe9a4c298214223ff89d06401ac7b66f81c98.1277911346.git.siccegge@cs.fau.de>
 <1277974545-30331-1-git-send-email-nicolas.ferre@atmel.com>
 <4C6E9CAC.4000404@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6E9CAC.4000404@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16389724945590889324
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:18 Fri 20 Aug     , Nicolas Ferre wrote:
> Le 01/07/2010 10:55, Nicolas Ferre :
> > The MTD nand driver for Atmel chips is atmel_nand and not at91_nand anymore.
> > Change wrong configuration variables that were remaining.
> > 
> > Reported-by: Christoph Egger <siccegge@cs.fau.de>
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> We can add:
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0IBWsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:48:00 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:49412 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752517Ab0IBWr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:47:59 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 18:47:58 EDT
Date: Fri, 3 Sep 2010 00:40:41 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Paul Chavent <paul.chavent@fnac.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        costa.antonior@gmail.com, nicolas.ferre@atmel.com, linux@maxim.org.za,
        linux@arm.linux.org.uk
Subject: Re: [PATCH] arm mach-at91 use choice keyword for board type
 selection in Kconfig
Message-ID: <20100902224041.GB21449@game.jcrosoft.org>
References: <4C800D37.6080703@fnac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C800D37.6080703@fnac.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2885118511971937175
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:46 Thu 02 Sep     , Paul Chavent wrote:
> It seems that we can select more than one board for one kernel.
> 
> This patch use a choice keyword for board type selection in Kconfig.
NACK

we do want to be able to compile mutliple board in the same kernel
and select it at runtime by the bootloader

Best Regards,
J.

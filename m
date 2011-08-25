Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1HYQwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:52:00 -0400
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:56320 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1HYQv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:51:58 -0400
X-Greylist: delayed 1797 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 12:51:58 EDT
Date: Thu, 25 Aug 2011 17:55:08 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nico Erfurth <ne@erfurth.eu>,
        Gregory Hermant <gregory.hermant@calao-systems.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v3] at91: merge board usb-a9260 and usb-a9263 together
Message-ID: <20110825155508.GB2284@game.jcrosoft.org>
References: <1314281314-28912-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314281314-28912-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8433553253332527980
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvledrtdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:08 Thu 25 Aug     , Nicolas Ferre wrote:
> From: Nico Erfurth <ne@erfurth.eu>
> 
> Merge boards together as they are barely the same.
> 
> Signed-off-by: Nico Erfurth <ne@erfurth.eu>
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> [nicolas.ferre@atmel.com: updated to new machine_desc structure]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Gregory Hermant <gregory.hermant@calao-systems.com>
> ---
> Hi,
> 
> I come back to this patch in the process of collecting things that has been
> left on the mailing-list.
> Gregory, can you have a loot at it?
> 
> v3: update the machine_desc structure to match latest improvements.
> v2: update against new common init
>     we must use it as we can detect the cpu type only after mapping
>     the system controler.
I've the hardware now

I'll re test it myself

I'm adding the usb-a9g20 right now too in the same fime

Best Regards,
J.

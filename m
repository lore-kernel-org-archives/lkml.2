Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1H3CLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:11:51 -0400
Received: from 1.mo1.mail-out.ovh.net ([178.32.127.22]:54987 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750966Ab1H3CLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:11:50 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 22:11:50 EDT
Date: Tue, 30 Aug 2011 03:36:15 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nico Erfurth <ne@erfurth.eu>,
        Gregory Hermant <gregory.hermant@calao-systems.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v3] at91: merge board usb-a9260 and usb-a9263 together
Message-ID: <20110830013615.GE20128@game.jcrosoft.org>
References: <1314281314-28912-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314281314-28912-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4851502699284900716
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrtdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
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
Tested

Best Regards,
J.

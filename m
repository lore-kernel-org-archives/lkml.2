Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987Ab1IOPAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:00:53 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:59893 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756278Ab1IOPAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:00:51 -0400
Date: Thu, 15 Sep 2011 16:38:57 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Leo Yan <leoy@marvell.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        haojian.zhuang@marvell.com, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 2/2] ARM: mmp: add audio sram allocator
Message-ID: <20110915143857.GL28104@game.jcrosoft.org>
References: <1312167547-26740-1-git-send-email-leoy@marvell.com>
 <1312167547-26740-3-git-send-email-leoy@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312167547-26740-3-git-send-email-leoy@marvell.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1376975587737840442
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrfeefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:59 Mon 01 Aug     , Leo Yan wrote:
> Implement the audio sram allocator with genalloc,
> so that can dynamically allocate the buffer
> to pcm devices as need.
> 
> Signed-off-by: Leo Yan <leoy@marvell.com>
this can be more generic nad move to lib/genalloc.c

Best Regards,
J.

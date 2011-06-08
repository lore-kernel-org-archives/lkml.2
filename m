Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1FHPUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:20:41 -0400
Received: from 23.97.mail-out.ovh.net ([87.98.169.92]:43190 "EHLO
	97.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756554Ab1FHPUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:20:38 -0400
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jun 2011 11:20:38 EDT
Date: Wed, 8 Jun 2011 15:48:32 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: mchehab@redhat.com, g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lars.haring@atmel.com, ryan@bluewatersys.com, arnd@arndb.de
Subject: Re: [PATCH v4] [media] at91: add Atmel Image Sensor Interface
 (ISI) support
Message-ID: <20110608134832.GB17584@game.jcrosoft.org>
References: <1307497219-21496-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307497219-21496-1-git-send-email-josh.wu@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9279385558617533199
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: Vade Retro 01.320.21 AV+AS Profile: OVH; Bailout: 300; @!Recipients (-100); (-100)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:40 Wed 08 Jun     , Josh Wu wrote:
> This patch is to enable Atmel Image Sensor Interface (ISI) driver support.
> - Using soc-camera framework with videobuf2 dma-contig allocator
> - Supporting video streaming of YUV packed format
> - Tested on AT91SAM9M10G45-EK with OV2640
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
looks fine
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.

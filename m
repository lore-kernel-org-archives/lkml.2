Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1IZHBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:01:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47311 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1IZHBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:01:12 -0400
Subject: Re: [PATCH] mxc_nand: preset_v1_v2: unlock all NAND flash blocks
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Michael Thalmeier <michael.thalmeier@hale.at>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 26 Sep 2011 10:03:59 +0300
In-Reply-To: <1316778824-12518-1-git-send-email-michael.thalmeier@hale.at>
References: <1316778824-12518-1-git-send-email-michael.thalmeier@hale.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317020649.9442.1.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 13:53 +0200, Michael Thalmeier wrote:
> From: Wolfram Stering <wolfram.stering@hale.at>
> 
> For NFC v1, the unlock end block address was 0x4000, which would only
> unlock the first 32 blocks of the NAND flash.  Change that value to
> 0xffff to unlock all available blocks, as is done for NFC v21 as well.
> 
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>

Pushed to l2-mtd-2.6.git tree, thanks!

-- 
Best Regards,
Artem Bityutskiy


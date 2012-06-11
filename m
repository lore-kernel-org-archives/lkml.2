Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2FKOQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:16:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55147 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2FKOQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:16:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 8/14] ARM: LPC32xx: Clock adjustment for key matrix controller
Date: Mon, 11 Jun 2012 14:16:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
References: <1339412537-24485-1-git-send-email-stigge@antcom.de> <1339412537-24485-9-git-send-email-stigge@antcom.de>
In-Reply-To: <1339412537-24485-9-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111416.19251.arnd@arndb.de>
X-Provags-ID: V02:K0:/IocTd1sYfASqBjbs1409nfUMHvkJ8GFG4JxMVUQd9r
 sbJwZzfNX7uStBPUxqP38rlm0vFRN/y2qrrNu74Q+PBLiUQCt4
 FY3x7VkkejoBkSREmsHwg3XQWglkuGTihykUj1QvqC+mzlp586
 LTiNMqPIQ2MkG0vuryIA3GF7zuzxvX3290qdQGAKNBPyA7U6lA
 ZQ1NebNQ0tsihZ2QGQD2aRyxvNC2n0yuHxa/mzKwmWwsjcE9No
 1l+GXhOHRCeTKaqg4fxUISZ3TMf5OFaQZ06aWYaqn2FHe053pW
 wQALnlZWq4q2sD3uToG5ndkjcXsUembWSELN8WBztJULaTCbrY
 FUO104+ip9n13gO14z6Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Roland Stigge wrote:
> The clock.c file needs to be changed to match the automatic device name to its
> clock.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> 

Should this not be in the same patch as the one that moves the device over
to DT probing? Otherwise you have a non-working setup if only one patch
is applied.

	Arnd

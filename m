Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2GKNZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:25:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab2GKNZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:25:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2 04/23] ARM: LPC32xx: Add DMA configuration to platform data
Date: Wed, 11 Jul 2012 13:25:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
References: <1339692673-7848-1-git-send-email-stigge@antcom.de> <201207111233.24780.arnd@arndb.de> <4FFD744F.8060204@antcom.de>
In-Reply-To: <4FFD744F.8060204@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111325.03195.arnd@arndb.de>
X-Provags-ID: V02:K0:DFTYRgcXMy5zsUFB9hsxgjAqvMZ9XE9hOLeMdcpYtQ6
 p/K7XXtAdW7GNi0njYz0d7kmuzI+tiMYPkw73WnktcFMKrQ4qo
 6rI14kS4eL0CecggntqxzeSPa0ZqDq2v4SPhyXdescLsPfj2UB
 k07DyMEdN6hDuM+a+02HrWBa2hkkpQJkbqhm8x3hyBcwVqKYzw
 D3suJHVemRojPtUoWL/RQXOw7L66wBZ5+IJ6PefTk219hK1Lzf
 vX7ENlqNg2tmHz3bB9C3TjviXrhDGGHxh2zhnS88GgKtZBL5Iu
 L6j+K6IqwO8YefPTnxcfkmAzEoO5D77+GhQZc5KTltYdCH3vWU
 GpFnE1ktuN7YxGsMKzKU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2012, Roland Stigge wrote:
> OK, thanks!
> 
> Is a patch on top of the already provided lpc32xx-next branches the
> preferred form for a fix? On top of which branch do you need it?
> 

Yes, I think in this case, changing it on top of that branch is best.

I'm not sure how that works for the nand drivers though, since they
are in another tree.

	Arnd

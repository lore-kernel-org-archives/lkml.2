Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab1IIIH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:07:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55938 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461Ab1IIIHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:07:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v3 08/36] Hexagon: Add delay functions
Date: Fri, 09 Sep 2011 10:07:05 +0200
Message-ID: <7440179.BsgeraFyS5@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010915.450346603@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010915.450346603@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fYDSwZPHAlz+Fa2uPrqO2OlWUn0+bi72RX99pFj4kar
 Rqa6SieCBHTcgGb8+C76Vm7SQEzV5WqAfI38i2dznRYEh7SJPk
 uSV3RX4NgclFuA9j0k5nEy0Epbcr7HRXky+VxNB9NXjRhxE7dO
 z9rTM9dmTZv3PciGyHYDXtKnp25Fq0KaFyioo46P7YApCup3bi
 9+QLrJ4D7Gg9zZgpFa4vc32ajgmSKP6th5brU5wIxDENcrzvZS
 P3HmhmvGTVNDkiTVp61hkmzICAlY0vWqatmqsmD80vsSrysRw5
 9UXrP0rbaFIhYXJ0tPIFZOLEBCAJwMHgvnlmVPB8EQXs91cT3E
 YWJbrQotsRSEBEfRcusE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:08:55 Richard Kuo wrote:
> Added read_current_timer elsewhere.
> 
> udelay is based off of __vmgettime() which returns processor ticks.
> 
> Removed __delay and CONFIG_GENERIC_CALIBRATE_DELAY.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

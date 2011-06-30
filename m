Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1F3Lag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:30:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1F3Laa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:30:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 2/3] ARM mxs: adjust pwm resources to what the driver expects
Date: Thu, 30 Jun 2011 13:30:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de> <1309430517-23821-3-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1309430517-23821-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301330.07645.arnd@arndb.de>
X-Provags-ID: V02:K0:yHdjhSlY78w+PIjCUawRQh6KTv/mNMbpvsZhySGK5TP
 3rltMeDG9zIo+mm7eAB2qnQwLwDFEvw/LcxmP5e9wgso8fDVkh
 QVkz4j0IO3qm2c7G1j3Sq4NwDdW8PVSUUtwkO6hl6HEPB0kFQ8
 2y53ZYUPsQJm2m0LEJ1doThdoFnvFmUJmYuSNz2afYKbsq+kfE
 a40UDSAyaqJtXMHZ3TLQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 June 2011, Sascha Hauer wrote:
> The PWMs on i.MX23/28 have almost seperated register spaces
> but share a common enable register. To reflect this register
> a parent device to the PWMs which handles the enable register.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

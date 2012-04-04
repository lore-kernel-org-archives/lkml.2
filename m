Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab2DDUAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:00:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab2DDUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:00:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCHv3 3/3] misc: add support for bmp18x chips to the bmp085 driver
Date: Wed, 4 Apr 2012 20:00:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com, stefan.nilsson@unixphere.com
References: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com> <1333568759-13536-4-git-send-email-eric.andersson@unixphere.com> <20120404195532.GB10787@opensource.wolfsonmicro.com>
In-Reply-To: <20120404195532.GB10787@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204042000.34160.arnd@arndb.de>
X-Provags-ID: V02:K0:gebLDcHyJjbx+Kg06nMbWYw4FXN36piuKnY60YsjwuA
 +7qzVOwCGnHMdRVesCAa41sWqZiy515O80R9ueg1z11lm7tghP
 /3bPuNC8mSylFDVQPR2184FzeMSRComj2EUhWkSd5uCUEoLnTY
 Dgl11X+DiBcjUIv5TxtmgQ240yM6CqbXJlc2g/miaeUyg0BB82
 FwFMOt2cCmuVXy3bidgOKYtNsJaK3wT0QhB+Dp38KmauLRigYN
 3moWTcnILRBKwEtAK4KYUIedkMdphLBl7Z8G+PAk1w26NlJhro
 Wv0sxXilcn1TqKQz7bK+vHonE3uIdAB1dZYMZ/hgcHJPh93xNi
 aO9cf+oSQMZrZ/lp3onU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2012, Mark Brown wrote:
> > +static const struct of_device_id bmp085_of_match[] = {
> > +     { .compatible = "bosch-sensortec,bmp085", },
> 
> Traditionally the stock ticker symbol would be used.

I though about commenting on that as well, but since Bosch is a foundation
and not publically traded, that would be hard to accomplish. Is there
an official fallback for companies that don't have a stock ticker symbol?

	Arnd

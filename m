Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab2CUPeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:34:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34558 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab2CUPd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:33:59 -0400
MIME-Version: 1.0
In-Reply-To: <1332343445-17104-1-git-send-email-meltedpianoman@gmail.com>
References: <1332343445-17104-1-git-send-email-meltedpianoman@gmail.com>
Date: Wed, 21 Mar 2012 16:33:58 +0100
Message-ID: <CAMSQXEFOrVqShK2U3q5Yzh8zOy-is7vYfptarqVnMSRRFp4vPQ@mail.gmail.com>
Subject: Re: [PATCH] Support M95040 SPI EEPROM
From: Ivo Sieben <meltedpianoman@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Updated the generic SPI EEPROM driver AT25 for support of address bit A8
> in the instruction byte. Certain EEPROMS (like M95040 from ST) have a 512
> Byte size but use only one address byte (A0 to A7) for addressing. For the
> extra address bit A8 bit 3 of the instruction byte is used. This instruction
> bit is threated as don't care for other AT25 like chips
>
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>

I cannot find a maintainer for the at25 driver.
Therefor I've send a CC to some people that made contributions to this driver.

I hope you can take a look at it.

Best regards,
Ivo Sieben

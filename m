Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1JBSQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:16:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50772 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab1JBSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:16:15 -0400
Date: Sun, 2 Oct 2011 19:16:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 02/26] sound/pxa-zylonite: use a valid device for
 dev_err()
Message-ID: <20111002181611.GA2857@opensource.wolfsonmicro.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <1317499438-14058-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317499438-14058-3-git-send-email-arnd@arndb.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 10:03:34PM +0200, Arnd Bergmann wrote:
> A recent conversion has introduced references to &pdev->dev, which does
> not actually exist in all the contexts it's used in.

> Replace this with card->dev where necessary, in order to let
> the driver build again.

Applied, thanks.  I'm a bit confused about why this is buried in the
middle of some enormous series of some kind?

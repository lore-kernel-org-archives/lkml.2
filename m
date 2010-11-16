Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab0KPICT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:02:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63118 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab0KPICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SYR6zsxeFrx7qnxqIX4EvqSw2C4JPSUYpygM5LcNrHmZvcdnRi3VNs+5aXp/Q/UhJ7
         H5sLl7gbQbay2q5qCWW6neM91Thvu4IxmFDreAuaYpCjI7yZikzNb2HXC/w8VhAa8FKd
         /x24DSGXLIRoiuF1aWltnQ7LyvJgff6kkEbyg=
Subject: [PATCH 0/5] ASoC: Fix incorrect kfree in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Barry Song <21cnbao@gmail.com>,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        Richard Purdie <richard@openedhand.com>
Content-Type: text/plain
Date: Tue, 16 Nov 2010 16:06:40 +0800
Message-Id: <1289894800.19543.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial of patches fixes incorrect kfree in error path.

Axel Lin (5):
  ASoC: Fix incorrect kfree in ad1836_probe error path
  ASoC: Fix incorrect kfree in ad193x_probe error path
  ASoC: Fix incorrect kfree in aic3x_probe error path
  ASoC: Fix incorrect kfree in wm8731_probe error path
  ASoC: Fix incorrect kfree in wm8962_probe error path

 sound/soc/codecs/ad1836.c      |    1 -
 sound/soc/codecs/ad193x.c      |    1 -
 sound/soc/codecs/tlv320aic3x.c |    1 -
 sound/soc/codecs/wm8731.c      |    1 -
 sound/soc/codecs/wm8962.c      |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

-- 
1.7.2




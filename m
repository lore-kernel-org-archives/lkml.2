Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0K2Jci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:32:38 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63229 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab0K2Jch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:32:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=HEmCvuGUKVboNMT6/h7cVSY3njgcI3m3p0FaMV+esAvxsrDLVBBLdOw/e7dx66wA3Q
         7UefZFsSXX4I4/jNhq62duhyMSZqjJEJi2bN85k33ClWb5Hl3SP0sutupDyCQnmitKvK
         wKRw9OZXYOrkRLE+VlYIqUrAtr7T7ptS/oYdo=
Subject: [PATCH 0/5] Fix compile error and missing spin_unlock_irqrestore
	for NUC900 SoC audio
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Mon, 29 Nov 2010 17:38:11 +0800
Message-Id: <1291023491.22911.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial fixes compile error and missing spin_unlock_irqrestore for NUC900 SoC audio.

Regards,
Axel

Axel Lin (5):
  ASoC: Fix compile error for nuc900-ac97.c
  ASoC: Fix prototype for nuc900_ac97_probe and nuc900_ac97_remove
  ASoC: Fix compile error for nuc900-pcm.c
  ASoC: Fix missing spin_unlock_irqrestore
  ASoC: Remove unneeded !! operations while checking return value of
    nuc900_checkready

 sound/soc/nuc900/nuc900-ac97.c  |   15 +++++++--------
 sound/soc/nuc900/nuc900-audio.h |    2 ++
 sound/soc/nuc900/nuc900-pcm.c   |   11 ++++++-----
 3 files changed, 15 insertions(+), 13 deletions(-)

-- 
1.7.2




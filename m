Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1IVKka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 06:40:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45373 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1IVKk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 06:40:27 -0400
Subject: ASoC: Is there a missing entry in wm5100_bclk_rates_dat array?
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 18:40:17 +0800
Message-ID: <1316688017.2355.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
I just found the size of wm5100_bclk_rates_dat array is 19,
but there are only 18 entries initialized in current code.
I'm not sure if there is a missing entry in wm5100_bclk_rates_dat array
or not. Could you help to check it again?

#define WM5100_NUM_BCLK_RATES 19

static int wm5100_bclk_rates_dat[WM5100_NUM_BCLK_RATES] = {
        32000,
        48000,
        64000,
        96000,
        128000,
        192000,
        384000,
        512000,
        768000,
        1024000,
        1536000,
        2048000,
        3072000,
        4096000,
        6144000,
        8192000,
        12288000,
        24576000,
};

Thanks,
Axel



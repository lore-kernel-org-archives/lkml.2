Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab1LQJdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 04:33:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38578 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1LQJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 04:33:13 -0500
Message-ID: <1324114379.28427.1.camel@phoenix>
Subject: ASoC: missed hx4700-audio platform device for hx4700
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.ru>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Sat, 17 Dec 2011 17:32:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iPAQ hx4700 machine driver needs a hx4700-audio platform device which is
not (yet) merged.

The patchs was post on LKML: https://lkml.org/lkml/2011/5/18/222
but [PATCH v3 3/3] pxa/hx4700: add platform device and I2C info for AK4641 codec is missed.

Regards,
Axel



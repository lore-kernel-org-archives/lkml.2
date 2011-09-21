Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab1IUCWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 22:22:55 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:60434 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750715Ab1IUCWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 22:22:54 -0400
Message-ID: <4E794A96.9040206@marvell.com>
Date: Wed, 21 Sep 2011 10:23:18 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Questions for dummy codec driver
References: <1316502540.4269.1.camel@phoenix>
In-Reply-To: <1316502540.4269.1.camel@phoenix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2011 02:21:04.0533 (UTC) FILETIME=[1D1A3C50:01CC7805]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

I have a question for the dummy codec.

As you know, sometimes maybe we only need set the timing from the 
processor, and codec just only need tx/rx data; So there do not need the 
codec driver.

After browser the code, there have NO such a dummy codec driver; and for 
soc-core, there have not such flags to support this situation.
Only what i get is sound/soc/codecs/spdif_transciever.c, but it's 
specific for TI's DaVinci platform.

I want to get the right direction, so here have some works or discussing 
for that?

Thx,
Leo Yan

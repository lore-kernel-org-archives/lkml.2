Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2GWTOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:14:54 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59226 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2GWTOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:14:53 -0400
From: Florian Fainelli <florian@openwrt.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Clocksource/clockevent with non self-reloading timer blocks?
Date: Mon, 23 Jul 2012 21:14:49 +0200
Message-ID: <1772014.SXB9lS46ng@bender>
Organization: OpenWrt
User-Agent: KMail/4.8.4 (Linux/3.2.0-26-generic; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The SoC I work on (Moschip MCS8140) has several timer blocks, but none of them 
are self-reloading timers, yet I can enable/disable the free-running timer, 
and enable/disable the interrupt generation.

Are there any existing in kernel clocksource/clockevent drivers with the same 
constraints?

Thank you very much for your answer.
-- 
Florian

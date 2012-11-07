Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab2KGGMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:12:08 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61714 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2KGGMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:12:06 -0500
MIME-Version: 1.0
Date: Wed, 7 Nov 2012 11:42:04 +0530
Message-ID: <CAPub14-CPS48gQ1h8vvAYBpO_=egjheG_rMoZ894Y4XZ2CinUQ@mail.gmail.com>
Subject: possibility of parent clock selection through DT
From: Shiraz Hashim <shiraz.linux.kernel@gmail.com>
To: Mike Turquette <mturquette@ti.com>, Rob Herring <rob.herring@calxeda.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Rob,

Devices in a SoC can have multiple possible clock sources which is
perfectly captured through clk framework.

But the device itself may not be aware of the complex hierarchy above it.
In this case how do you suggest a board (through DT) should select its
preference.

Is there some work already going on in this direction ?

-- 
regards
Shiraz Hashim

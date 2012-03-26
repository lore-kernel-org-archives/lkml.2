Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2CZKOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:14:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55152 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab2CZKOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:14:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAHgx9OcGk8-3nONq3d6VVdhjGuhW1fjDfu=yNL10UjGyykQtdg@mail.gmail.com>
References: <CAHgx9OcGk8-3nONq3d6VVdhjGuhW1fjDfu=yNL10UjGyykQtdg@mail.gmail.com>
Date: Mon, 26 Mar 2012 15:44:48 +0530
Message-ID: <CAHgx9OfQon=eHSiqAzuz-ODLajepJx44=RgJpz6yG2sA1X5pZw@mail.gmail.com>
Subject: DW Watchdog Code
From: Tushar K <tushark.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am going through the DW Watchdog code in linux kernel 3.3 (dw_wdt.c)
file. I could not see any interrupt handling in this file. Am I
missing something?
Please tell me how interrupt is getting handled in this case? Also how
to add this device into the Linux kernel? (I tried to check few BSPs
but could not find which is using this IP.)
I wanted to look at the other SoC BSP to see how that's been used for reference.

Thanks & Regards,
Tushar

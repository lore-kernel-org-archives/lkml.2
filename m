Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1IFNee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:34:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41770 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1IFNe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:34:28 -0400
MIME-Version: 1.0
Date: Tue, 6 Sep 2011 17:34:27 +0400
Message-ID: <CAFZPMobCZf4K_JVhSnXt_R++nG0afxdEL=Xqr5j6zoE=YkoQbw@mail.gmail.com>
Subject: USB: isp1362
From: Sergey Lapin <slapinid@gmail.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!
Is there known working board which runs Linux-2.6.32 or later and has
working isp1362 USB OTG controller?

I try to make isp1362 work on PowerPC architecture. It works perfectly
well when I define
#define CONFIG_USB_DEBUG
#define DEBUG
on top of file.
I need only host mode.

I've investigated trying to check which debug messages might trigger
working state
inserting udelays instead of them, but it seems too unstable and flaky.

Any help is appreciated.

All the best,
S.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1ECOrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:47:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1ECOrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:47:37 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=3rvgeqzMqd0A:10 a=zDvABA4frbYA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=DsYFPeKDPV-PxgLhvOsA:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Tue, 03 May 2011 09:47:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        chaoming_li@realsil.com.cn
Subject: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
Message-ID: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches introduces a driver for the RTL8192SE PCI devices.

The patches are as follows:

01/12: Introduce file def.h
02/12: Introduce dynamic management routines dm.c and dm.h
03/12: Introduce firmware routines fw.c and fw.h
04/12: Introduce hardware control routines hw.c and hw.h
05/12: Introduce LED routines led.c and led.h
06/12: Introduce PHY routines phy.c and phy.h
07/12: Introduce register definition header
08/12: Introduce radio control routines
09/12: Introduce main routine (sw.c and sw.h)
10/12: Introduce tables
11/12: Introduce TX/RX routines
12/12: Modify Kconfig and Makefiles to build rtl8192se

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This material is for 2.6.40.

Larry


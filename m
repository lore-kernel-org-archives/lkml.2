Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0JGTPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:15:04 -0400
Received: from smtp.nokia.com ([192.100.122.233]:44722 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab0JGTPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:15:03 -0400
Date: Thu, 07 Oct 2010 22:14:01 +0300 (EEST)
Message-Id: <20101007.221401.226802875.Hiroshi.DOYU@nokia.com>
To: x0095840@ti.com
Cc: felipe.contreras@nokia.com, ameya.palande@nokia.com, david.cohen@nokia.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <1286477021-23169-1-git-send-email-x0095840@ti.com>
References: <1286477021-23169-1-git-send-email-x0095840@ti.com>
X-Mailer: Mew version 7.0.50 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2010 19:14:09.0008 (UTC) FILETIME=[D14E4F00:01CB6653]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ext Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH] iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF
Date: Thu, 7 Oct 2010 20:43:41 +0200

> IV2 MMU capable addresses start from 0x11000000

Wouldn't it be better to add an general API to configure the valid
'da' range in advance?

I don't think that it's a good idea to introduce the iommu
instance("iva2:iommu") specific code here.

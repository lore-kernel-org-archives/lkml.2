Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0EKSyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:54:21 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:37192 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0EKSyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:54:18 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       bryan.wu@canonical.com, amit.kucheria@canonical.com
Subject: PATCHv1 0/1 Enable ulpi phy on freescale mx51 babbage hw
Date: Tue, 11 May 2010 13:53:40 -0500
Message-Id: <1273604021-857-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was accidently left out of the original set of patches for
enabling USB Host support on Freescale's MX51 Babbage HW. This patch
brings the USB ULPI PHY on Host1 out of reset, which is required for
enabling Host1 of the hardware.

Thanks,
Dinh Nguyen



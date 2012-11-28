Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab2K1UKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:10:22 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56069
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab2K1UKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:10:21 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: drivres/hv 
Date: Wed, 28 Nov 2012 12:17:30 -0800
Message-Id: <1354133850-17540-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Greg,

I recently discovered that the Hyper-V host allocates mmio
memory for some synthetic devices like the virtual framebuffer.
We are currently in the process of implementing this virtual
framebuffer device. As part of the offer message from the host
we are given the mmio region size that needs to be allocatted to
the device. I am told in the current implementation of the firmware,
this mmio resource shows up in the PCI space. What is the best way to
allocate this mmio space for this driver.


Regards,

K. Y


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1HQRFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:05:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61481 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab1HQRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:05:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110806945"
Message-Id: <20110817163457.878854582@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:34:57 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 00/36] Hexagon: Add support for Qualcomm Hexagon architecture
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch set is intended to add support for the Qualcomm Hexagon
architecture to the Linux kernel.

The Hexagon architecture is designed to deliver performance with low power
over a variety of applications.  It has features such as multithreading,
privilege levels, VLIW, and instructions geared toward efficient signal
processing.  The port of Linux for Hexagon runs under a hypervisor layer.

I realize we are not currently in a merge window, but I felt it would be best
to go ahead and send it out so that the community gets an ample chance to
review it.  This is a very large patch set, but we've tried to break it up
into functional pieces to make review easier.

These changes are available in patch form on the Code Aurora Forum:

https://www.codeaurora.org/patches/quic/hlk/hexagon-linux-20110817.tar.gz

and will also be available via git:

git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon.git hexagon

Any feedback will be greatly appreciated.

Thanks,
Richard Kuo


Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

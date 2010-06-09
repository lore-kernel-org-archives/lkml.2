Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab0FIXIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:08:46 -0400
Received: from www.tglx.de ([62.245.132.106]:42929 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab0FIXIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:08:45 -0400
Date: Thu, 10 Jun 2010 01:08:41 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] uio: Remove IRQF_DISABLED flag from Userspace IO
 drivers
Message-ID: <20100609230841.GB2555@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt flag IRQF_DISABLED is deprecated now. This small patch series
removes all uses of this flag in drivers/uio/.

Thanks,
Hans


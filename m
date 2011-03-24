Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab1CXV1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:27:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:39934 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755085Ab1CXV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:27:36 -0400
Message-Id: <20110324212330.292903803@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 24 Mar 2011 21:27:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [patch 0/3] gpio: Final genirq cleanups
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

if possible, please push this lot to Linus for .39. It's cleaning up
the missing bits and pieces which are necessary to remove all the
compat cruft in the genirq code.

Thanks,

	tglx


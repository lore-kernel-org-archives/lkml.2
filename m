Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1BFXjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:19 -0500
Received: from www.tglx.de ([62.245.132.106]:40308 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab1BFXjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:18 -0500
Message-Id: <20110206233845.480884215@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 00/10] m68knommu: Convert irq_chips and use proper accessor
	functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's a conversion to the new irq_chips and a cleanup to irq_desc
accessor functions. Finally it sets GENERIC_HARDIRQS_NO_DEPRECATED.

Warning: untested.

Thanks,

	tglx




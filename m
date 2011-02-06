Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1BFTWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:22:04 -0500
Received: from www.tglx.de ([62.245.132.106]:45153 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab1BFTWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:22:03 -0500
Message-Id: <20110206192032.393682621@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:21:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 0/7] frv: Convert to new irq_chip functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series converts frv to the new irq_chip functions.

I compiled only the affected files, as the whole thing does not build.

Thanks,

	tglx


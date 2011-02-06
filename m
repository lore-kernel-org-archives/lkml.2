Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1BFVp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:45:58 -0500
Received: from www.tglx.de ([62.245.132.106]:45927 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1BFVp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:45:56 -0500
Message-Id: <20110206214441.438777646@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:45:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 0/7] mn10300: Convert to new irq_chip functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to new irq_chip functions and select GENERIC_HARDIRQS_NO_DEPRECATED

Untested due to lack of hardware and compiler.

Thanks,

	tglx



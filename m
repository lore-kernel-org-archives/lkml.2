Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab1BQRBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:01:18 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:37182 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab1BQRBP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:2>);
	Thu, 17 Feb 2011 12:01:15 -0500
Message-Id: <4D5D629D02000078000327E1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 17 Feb 2011 17:02:05 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tony.luck@intel.com>, <tglx@linutronix.de>,
        <hpa@zytor.com>
Cc: <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] generalize exception table implementation to deal
	 with relative pointers
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow x86-64 to shrink its exception tables by half, and ia64 to
drop its custom implementation.

1/3: x86-64: use macros to generate exception table entries
2/3: x86-64: use relative 32-bit pointers in exception tables
3/3: ia64: drop custom exception table implementation

Signed-off-by: Jan Beulich <jbeulich@novell.com>


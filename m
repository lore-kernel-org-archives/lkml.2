Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0LGWRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:17:17 -0500
Received: from relay2.sgi.com ([192.48.179.30]:59680 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754184Ab0LGWRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:17:14 -0500
Message-Id: <20101207221430.309660089@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 07 Dec 2010 16:14:30 -0600
From: steiner@sgi.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/2] X86, UV Ignore node controller ID bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches fix problems dealing with large SGI UV systems.
When large systems with lots of node are broken into multiple
SSIs, the node controller has extra ID bits that must be ignored.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0K3T73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:59:29 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44527 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751660Ab0K3T72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:59:28 -0500
Message-Id: <20101130195538.140935652@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 30 Nov 2010 13:55:38 -0600
From: steiner@sgi.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/2] x86, UV: UV fixes for extra bits in nodeid register
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches fix problems dealing with large SGI UV systems.
When large systems with lots of node are broken into multiple
SSIs, the node controller has extra ID bits that must be ignored.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840Ab0HMPUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:20:34 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47116 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761754Ab0HMPUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:20:16 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>
Subject: [PATCH 0/9] RapidIO: Set of patches to add Gen2 switches
Date: Fri, 13 Aug 2010 11:17:57 -0400
Message-Id: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of RapidIO patches adds support for new IDT Gen2 sRIO switch
devices - CPS-1848 and CPS-1616.
Adding these sRIO switches required to implement standard error recovery
mechanism defined by the RapidIO specification.


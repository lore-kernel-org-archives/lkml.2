Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0INPEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:04:44 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56675 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab0INPEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:04:42 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH v2 0/10] RapidIO: Set of patches to add Gen2 switches
Date: Tue, 14 Sep 2010 10:59:13 -0400
Message-Id: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of RapidIO patches extends support for standard error recovery
mechanism and adds new IDT Gen2 sRIO switch devices - CPS-1848 and CPS-1616.
Implementation of the standard error-stopped state recovery mechanism (as
defined by the RapidIO specification) is required for the new switches.

The version 2 of this set of patches addresses received comments and fixes
an error notification setup issue found in the idt_gen2.c after the first
version was released.

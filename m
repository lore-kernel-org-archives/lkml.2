Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab2CMS4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:56:09 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:34271
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159Ab2CMS4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:56:07 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0U799-02-2HJ-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <x86@kernel.org>, <len.brown@intel.com>, <linux-acpi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH 0/2] Improve power consumption for off-lined cores
Date: Tue, 13 Mar 2012 19:55:08 +0100
Message-ID: <1331664910-20095-1-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch allows an off-lined core to enter C2 state (if available)
instead of C1. 

It also fixes declaration of power-state to be a signed integer.

-boris


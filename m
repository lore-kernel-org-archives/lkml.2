Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0JHOBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:01:12 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:29813 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0JHOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:00:44 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9Z5KV-02-0J7-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/7] oprofile, x86: Add support for AMD family 14h
Date: Fri, 8 Oct 2010 15:56:27 +0200
Message-ID: <1286546192-18593-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
References: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for AMD family 14h (Ontario/Zacate) cpus.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 0b0d1d6..4e8baad 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -729,6 +729,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		case 0x12:
 			cpu_type = "x86-64/family12h";
 			break;
+		case 0x14:
+			cpu_type = "x86-64/family14h";
+			break;
 		default:
 			return -ENODEV;
 		}
-- 
1.7.2.2



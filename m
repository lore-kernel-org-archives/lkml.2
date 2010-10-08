Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab0JHOAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:00:45 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:31807 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab0JHOAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:00:42 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9Z5KW-02-0JC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/7] oprofile, x86: Add support for AMD family 12h
Date: Fri, 8 Oct 2010 15:56:26 +0200
Message-ID: <1286546192-18593-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
References: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for AMD family 12h (Llano) cpus.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index bd1489c..0b0d1d6 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -726,6 +726,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		case 0x11:
 			cpu_type = "x86-64/family11h";
 			break;
+		case 0x12:
+			cpu_type = "x86-64/family12h";
+			break;
 		default:
 			return -ENODEV;
 		}
-- 
1.7.2.2



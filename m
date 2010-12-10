Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0LJLur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:50:47 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:37589
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558Ab0LJLuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:50:35 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LD7NK3-02-2UE-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/2] oprofile, x86: Add support for AMD family 15h
Date: Fri, 10 Dec 2010 12:49:05 +0100
Message-ID: <1291981746-22114-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291981746-22114-1-git-send-email-robert.richter@amd.com>
References: <1291981746-22114-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for AMD family 15h (Interlagos/Valencia/
Zambezi) cpus.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 4e8baad..358c8b9 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -732,6 +732,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		case 0x14:
 			cpu_type = "x86-64/family14h";
 			break;
+		case 0x15:
+			cpu_type = "x86-64/family15h";
+			break;
 		default:
 			return -ENODEV;
 		}
-- 
1.7.3.2



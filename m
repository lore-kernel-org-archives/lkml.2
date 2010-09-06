Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0IFNXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:23:34 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:35098
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754070Ab0IFNXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:23:22 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z5edIza3c1kzz1202hzz8275bh5eeePz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8BUAG-02-1GZ-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/4 -v2] x86: update AMD CPUID bits
Date: Mon, 6 Sep 2010 15:14:16 +0200
Message-ID: <1283778860-26843-1-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
 - pull SSE5^WXOP bit from KVM features to patch 1
 - add AES and F16C to list of propagated features
 - add kvm@vger to CC  ;-) 

Recently the public AMD CPUID specification
http://support.amd.com/us/Processor_TechDocs/25481.pdf
has been updated and revealed new CPUID flag feature names.
The following patches introduce them to the kernel to properly
display them in /proc/cpuinfo and allows KVM guests to use them.
Note: One bit has been renamed, so I propose patch 1/4 for inclusion
in the stable series.

Please apply!

Regards,
Andre.

--
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany



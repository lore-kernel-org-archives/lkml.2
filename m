Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2BIQI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:08:28 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18733 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753776Ab2BIQI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:08:27 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4VH2-02-AAQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 0/2] Fix perf-tool crashes when kvm guest is running
Date: Thu, 9 Feb 2012 17:07:37 +0100
Message-ID: <1328803659-30449-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are the fixes I promised. These patches should fix the crashes
David and Jason have seen by making sure no sample is processed when
ther is no valid machine object for it. The second patch also changes
the perf_guest default back to false.

Regards,

	Joerg



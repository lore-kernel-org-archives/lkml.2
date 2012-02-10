Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab2BJRFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:05:22 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:54175
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757966Ab2BJRFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:05:20 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ6SSL-02-8HA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 0/2 v2] Fix perf-tool crashes when kvm guest is running
Date: Fri, 10 Feb 2012 18:05:03 +0100
Message-ID: <1328893505-4115-1-git-send-email-joerg.roedel@amd.com>
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

v1->v2:

* Introduced counter for unprocessable samples
* Added ui warnings when unprocessable samples are found

Regards,

        Joerg




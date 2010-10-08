Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0JHOAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:00:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26070 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0JHOAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:00:42 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz4015Lzz1202hzzz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9Z5KU-02-0J6-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/7] oprofile, x86: updates for AMD family 12h and 14h systems
Date: Fri, 8 Oct 2010 15:56:25 +0200
Message-ID: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for AMD family 12h and 14h systems. Main
part here is the support of new IBS features (branch target address
reporting and periodic op counter extension).

Please review. If the patches are fine I will apply them to the
oprofile git repostitory on kernel.org. They depend on the APIC
patches I send out earlier.

Suravee will send updates to the oprofile userland soon.

Thanks,

-Robert




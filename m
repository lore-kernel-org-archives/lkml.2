Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0LJLuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:50:35 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:9713
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520Ab0LJLue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:50:34 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LD7NK1-01-2JO-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/2] oprofile, x86: updates for AMD family 15h systems
Date: Fri, 10 Dec 2010 12:49:04 +0100
Message-ID: <1291981746-22114-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending due to mail corruption)

This patch set adds support for AMD family 15h systems. It adds cpu
detection code for family 15h and implements support for 6 counters.

Suravee already sent updates for the oprofile userland to the oprofile
mailing list.

Please review. If the patches are fine I will apply them to the
oprofile git repostitory on kernel.org.

Thanks,

-Robert




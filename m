Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0JAQRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:17:15 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:51205
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375Ab0JAQRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:17:03 -0400
X-SpamScore: 4
X-BigFish: VS4(zz2f55kzz1202hzzz32i87h2a8h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9MCH4-02-D83-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 0/5] oprofile updates for v2.6.37
Date: Fri, 1 Oct 2010 17:56:22 +0200
Message-ID: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains some rework and cleanups of the oprofile code.
It also contains changes of the oprofile perf backend that is
currently implemented for the ARM architecture, but will be ported to
oprofile generic code.

Will, please ack the ARM changes if you are fine with it.

Matt, these patches may cause conflicts with your next patch set, so I
am fine with it if you are not rebasing your code. I will apply them
then to a different branch and solve the conflicts myself.

Ingo, this patch set is for review only. If there are no objections
with it I am going to apply it to my oprofile tree.

Thanks for review,

-Robert



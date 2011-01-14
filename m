Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab1ANPpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:45:40 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18672 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757650Ab1ANPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:45:31 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LF0RRN-01-IN6-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 v2] perf-kvm support for SVM
Date: Fri, 14 Jan 2011 16:45:00 +0100
Message-ID: <1295019902-31339-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the reworked version of the patch-set. Only patch 1/2 has
changed and now contains the real fix for the crashes that were seen and
has an updated log message.

Regards,

	Joerg



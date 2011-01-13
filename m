Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab1AMPXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:23:12 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58156 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757099Ab1AMPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:23:08 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEYW2B-01-NNM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] perf-kvm support for SVM
Date: Thu, 13 Jan 2011 16:22:56 +0100
Message-ID: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

these two patches finally implement perf-kvm support for AMD machines.
The meat is in the second patch. The first one is an important fix
which, when missing, causes system crashes when NMI happen while in
guest mode. So the first patch should also make it to the various
stable-queues.

Regards,

	Joerg



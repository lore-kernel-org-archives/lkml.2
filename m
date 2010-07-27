Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0G0QPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:15:16 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:56987 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0G0QPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:15:11 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L684ZQ-02-JAD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Nested SVM fix and next_rip emulation
Date: Tue, 27 Jul 2010 18:14:19 +0200
Message-ID: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

here are two small patches for kvm-amd. The first patch fixes a small bug in
nested svm efer handling. The second patch implements emulation for the
next_rip feature.

Regards,

	Joerg



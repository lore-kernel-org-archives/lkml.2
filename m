Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0HBOn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:43:56 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14827 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0HBOny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:43:54 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzzz32i2a8h87h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6J4WW-02-4IP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add some checks before emulating vmrun
Date: Mon, 2 Aug 2010 16:46:43 +0200
Message-ID: <1280760405-22591-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

as promised here are the patches that add the checks for the vmrun
intercept and the being != 0 at vmrun emulation in nested-svm.

	Joerg



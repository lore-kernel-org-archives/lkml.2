Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2ITRBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:01:36 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:49780 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab2ITRBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:01:34 -0400
From: ciminaghi@gnudd.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rubini@gnudd.com, sameo@linux.intel.com
Cc: giancarlo.asnaghi@st.com, linux-kernel@vger.kernel.org,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 0/2] x86, pci: sta2x11-fixup clock related patches
Date: Thu, 20 Sep 2012 18:44:07 +0200
Message-Id: <1348159449-21583-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Hi,

the following two patches are needed for the sta2x11 common clock
framework (to be submitted shortly) to deal with the possibility
of multiple instances of the connext chip on the same machine.

Davide Ciminaghi (2):
  x86, pci sta2x11-fixup: add clk related field to struct
    sta2x11_instance
  x86, pci sta2x11-fixup: add function to access sta2x11 instance id.

 arch/x86/include/asm/sta2x11.h |   16 ++++++++++++++++
 arch/x86/pci/sta2x11-fixup.c   |   20 ++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

-- 
1.7.9.1


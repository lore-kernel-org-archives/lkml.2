Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab1ERXb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:31:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:64110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab1ERXb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:31:57 -0400
X-ExtLoop1: 1
Message-Id: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 18 May 2011 16:31:30 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com
Subject: [patch 0/9] x86: ioapic cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Here is the latest patchset for ioapic cleanups that were
triggered by Daniel's observation of calling a sleeping function
with irq's disabled during suspend/resume.

Hopefully the code is in a better shape now for inclusion.

thanks,
suresh


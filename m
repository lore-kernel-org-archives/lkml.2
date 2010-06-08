Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0FHGJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:09:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:58919 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0FHGJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:09:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,383,1272870000"; 
   d="scan'208";a="286243779"
Subject: [PATCH -v3 0/2] x86, MCE, FIX MSR_IA32_MCI_CTL2_CMCI threshold
 setup (resend)
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Huang@vger.kernel.org,
       Ying <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 14:09:06 +0800
Message-ID: <1275977346.3444.658.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:

v3:

- Separate patch into 2 patches, one for renaming, the other for
threshold setup fixing.

v2:

- Rename CMCI_EN to MCI_CTL2_CMCI_EN and CMCI_THRESHOLD_MASK to
  MCI_CTL2_CMCI_THRESHOLD_MASK to make naming consistent.




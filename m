Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1IME2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 00:28:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:50403 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab1IME2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 00:28:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,372,1312182000"; 
   d="scan'208";a="52346198"
Message-ID: <4E6EDBFB.4010705@intel.com>
Date: Tue, 13 Sep 2011 12:28:43 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Iceowl/1.0b2 Icedove/3.1.13
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: What is the difference between percpu_xxx and this_cpu_xxx?
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If my understanding was correct, from the kernel source code, it appears
that percpu_xxx and this_cpu_xxx have the same semantics and
implementation in effect, haven’t them?

If so, why do we need two API for the same thing?

Best Regards,
Huang Ying

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2ILEk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 00:40:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:44641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2ILEkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 00:40:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,407,1344236400"; 
   d="scan'208";a="221025654"
Date: Wed, 12 Sep 2012 12:40:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [3.5.0 BUG] vmx_handle_exit: unexpected, valid vectoring info
 (0x80000b0e)
Message-ID: <20120912044037.GA23094@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

3 of my test boxes running v3.5 kernel become unaccessible and I find
two of them kept emitting this dmesg:

vmx_handle_exit: unexpected, valid vectoring info (0x80000b0e) and exit reason is 0x31

The other one has froze and the above lines are the last dmesg.
Any ideas?

Thanks,
Fengguang

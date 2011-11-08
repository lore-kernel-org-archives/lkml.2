Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1KHRLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:11:42 -0500
Received: from ams-iport-4.cisco.com ([144.254.224.147]:28272 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1KHRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:11:41 -0500
X-IronPort-AV: E=Sophos;i="4.69,477,1315180800"; 
   d="scan'208";a="2658710"
Date: Tue, 8 Nov 2011 22:33:36 +0530
From: Maneesh Soni <manesoni@cisco.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>, ananth@in.ibm.com,
        kamensky@cisco.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: [PATCH 0/4] MIPS Kprobes
Message-ID: <20111108170336.GA16526@cisco.com>
Reply-To: manesoni@cisco.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ralf,

Here is a set of 4 patches for MIPS kprobes. The first two are addressing 
a couple of baseline issues and the remaining two are the 2nd attempt for
allowing kprobes on jump and branch instructions based on the comments I got
earlier
	https://lkml.org/lkml/2011/10/13/106

1) Fix OOPS in arch_prepare_kprobe for MIPS 
2) Deny probes on ll sc instructions for MIPS
3) Refactoring Branch emulation
4) Support for branch instructions probing (v2)


Thanks
Maneesh


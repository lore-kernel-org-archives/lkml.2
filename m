Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0LIRWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:22:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:20533 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab0LIRWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:22:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="359433849"
Date: Thu, 9 Dec 2010 09:29:27 -0800 (PST)
From: "Mark A. Allyn" <mark.a.allyn@intel.com>
X-X-Sender: allyn@localhost.localdomain
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 0/11] Set of patches for sep driver
Message-ID: <alpine.DEB.2.00.1012090927180.18243@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 11 patches for the sep driver:

0001-sep-remove-virtual-address-being-passed-to-user-spac.patch
0002-sep-remove-spaces-at-end-of-lines.patch
0003-sep-sram_addr-is-32-bit-this-is-not-a-kernel-address.patch
0004-sep-clean-up-error-checking-in-probe-function.patch
0005-sep-initialize-driver-copy-of-send-and-receive-count.patch
0006-sep-remove-code-for-Moorestown-device.patch
0007-sep-remove-completed-items-in-TODO.patch
0008-sep-limit-time-to-wait-for-reconfig-shared-area-comp.patch
0009-sep-reduce-64-and-32-bit-compile-warnings.patch
0010-sep-ensure-that-caller-id-buffer-is-little-endian.patch
0011-sep-eliminate-kernel-crash-due-to-null-parameter-in-.patch

Mark Allyn

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1IMDD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 23:03:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:45943 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab1IMDDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 23:03:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,371,1312182000"; 
   d="scan'208";a="48050059"
From: "Brown, Len" <len.brown@intel.com>
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Date: Mon, 12 Sep 2011 20:03:52 -0700
Subject: ACPI git tree re-locates to github.com
Thread-Topic: ACPI git tree re-locates to github.com
Thread-Index: AcxxwcSrBB1fLED8Tfia3KhO3my/8g==
Message-ID: <E87738D94A6AD54789B5B8D1BAEB06CC829B3E4886@azsmsx503.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Effective immediately...

https://github.com/lenb/linux.git acpi

replaces

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git test

This is where I will consolidate ACPI-related patches for linux-next,
and upstream.

Note that I reserve the right to re-base this branch from time to time
as needed to revise or remove patches before they are pulled upstream.

Currently there are only a couple of patches on this branch,
and I'll use them as a test case to make sure the workflow is okay.

thanks,
-Len Brown
Intel Open Source Technology Center


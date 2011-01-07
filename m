Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1AGBFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:05:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:18141 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab1AGBFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:05:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,285,1291622400"; 
   d="scan'208";a="644301126"
From: "Luck, Tony" <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 6 Jan 2011 17:04:58 -0800
Subject: RE: linux-next: build warning after merge of the ia64 tree
Thread-Topic: linux-next: build warning after merge of the ia64 tree
Thread-Index: AcuuAPpgp4q+AwvCTZ+Iu7zB4dCNOQABWwEA
Message-ID: <987664A83D2D224EAE907B061CE93D53019400FDBC@orsmsx505.amr.corp.intel.com>
References: <20110107112143.2960451d.sfr@canb.auug.org.au>
In-Reply-To: <20110107112143.2960451d.sfr@canb.auug.org.au>
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

> Caused by commit ca01d6dd2d7a2652000307520777538740efc286 ("pstore:
> new filesystem interface to platform persistent storage").

Thanks for the bug report.  I just pushed a patch ... so this
should be fixed when you rebuild tomorrow:

commit 168f2e14319aba3125946649604e858cbae85be6
Author: Tony Luck <tony.luck@intel.com>
Date:   Thu Jan 6 16:58:58 2011 -0800

    pstore: fix build warning for unused return value from sysfs_create_file
    
    fs/pstore/inode.c: In function 'init_pstore_fs':
    fs/pstore/inode.c:266: warning: ignoring return value of 'sysfs_create_file', declared with attribute wa
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

-Tony

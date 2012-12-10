Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab2LJGpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:45:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:2739 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab2LJGpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:45:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,249,1355126400"; 
   d="scan'208";a="231534382"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: linux-next: manual merge of the net-next tree with the pci tree
Thread-Topic: linux-next: manual merge of the net-next tree with the pci tree
Thread-Index: AQHN1nLoE9Sru5aRzkGhg/YY1+lMhZgRlqrg
Date: Mon, 10 Dec 2012 06:44:45 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3018FADD5@HASMSX103.ger.corp.intel.com>
References: <20121210120825.49096bafd378139e98becb8d@canb.auug.org.au>
In-Reply-To: <20121210120825.49096bafd378139e98becb8d@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/wireless/iwlwifi/pcie/trans.c between commit b9d146e30a2d
> ("iwlwifi: collapse wrapper for pcie_capability_read_word()") from the pci
> tree and commit 7afe3705cd4e ("iwlwifi: continue clean up -
> pcie/trans.c") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action is
> required).
> 
Looks right - thanks Stephen!
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


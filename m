Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab2IZCdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:33:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12980 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2IZCdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:33:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6846"; a="241187539"
X-IronPort-AV: E=Sophos;i="4.80,487,1344236400"; 
   d="scan'208";a="124003655"
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20578.26916.325009.547470@gargle.gargle.HOWL>
Date: Wed, 26 Sep 2012 08:02:04 +0530
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Sujith Manoharan" <c_manoha@qualcomm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>
Subject: linux-next: manual merge of the wireless-next tree with the pci
 tree
In-Reply-To: <20120926120317.63d0b4acb0502bc4c2ffe4b8@canb.auug.org.au>
References: <20120926120317.63d0b4acb0502bc4c2ffe4b8@canb.auug.org.au>
X-Mailer: VM 8.2.0b under 24.2.1 (x86_64-unknown-linux-gnu)
X-Originating-IP: [10.100.2.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless-next tree got a conflict in
> drivers/net/wireless/ath/ath9k/pci.c between commit 08bd108096b6 ("ath9k:
> Use PCI Express Capability accessors") from the pci tree and commit
> 046b6802c8d3 ("ath9k: Disable ASPM only for AR9285") from the
> wireless-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The fix looks good, thanks.

Sujith

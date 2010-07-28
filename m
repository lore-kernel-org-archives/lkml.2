Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0G1Ro3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:44:29 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:42730 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab0G1Ro1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:44:27 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.55,275,1278288000"; 
   d="scan'208";a="164251661"
From: Roland Dreier <rdreier@cisco.com>
To: Peter =?utf-8?Q?H=C3=BCwe?= <PeterHuewe@gmx.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Faisal Latif <faisal.latif@intel.com>,
        Chien Tung <chien.tin.tung@intel.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/25] infiniband/hw/nes: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
References: <201007152101.21810.PeterHuewe@gmx.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 28 Jul 2010 10:44:26 -0700
In-Reply-To: <201007152101.21810.PeterHuewe@gmx.de> ("Peter =?utf-8?Q?H?=
 =?utf-8?Q?=C3=BCwe=22's?= message of
	"Thu, 15 Jul 2010 21:01:21 +0200")
Message-ID: <adawrsfec1x.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

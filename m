Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2DZJNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:13:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53363 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2DZJNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:13:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="185081049"
X-IronPort-AV: E=Sophos;i="4.75,484,1330934400"; 
   d="scan'208";a="304826313"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: RE: [PATCH 00/10] atl1c: update hardware settings - v3
Thread-Topic: [PATCH 00/10] atl1c: update hardware settings - v3
Thread-Index: AQHNI3Wo421SUud/iEyOaFswT6jiFpatRfAA//+MhAA=
Date: Thu, 26 Apr 2012 09:13:14 +0000
Message-ID: <157393863283F442885425D2C454285623D5E63C@nasanexd02a.na.qualcomm.com>
References: <1335421638-16304-1-git-send-email-xiong@qca.qualcomm.com>
 <20120426.050542.243663587525305831.davem@davemloft.net>
In-Reply-To: <20120426.050542.243663587525305831.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.45.230.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I will update quirks.c for the next patch set. Thanks !

-Xiong

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, April 26, 2012 17:06
> To: Huang, Xiong
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; qca-linux-team; nic-
> devel
> Subject: Re: [PATCH 00/10] atl1c: update hardware settings - v3
> 
> From: xiong <xiong@qca.qualcomm.com>
> Date: Thu, 26 Apr 2012 14:27:08 +0800
> 
> > This update contains a serial of patches, most of them are hardware
> > settings related. register definitions are refined (or removed if
> > meaningless) for each patch.
> >
> > This is the third serial patches, after reviewed/applied the fourth
> > serial will be out.
> >
> > The patches have addressed all sparse and checkpatch warnings.
> >
> > Following NICs are tested:
> > AR8131/AR8132/AR8151A/AR8152A/AR8152B
> > Test item includes:
> > build/install/uninstall/dhcp/ping/iperf/wol/reboot/etc.
> 
> I've applied patches #1 until #9, patch #10 needs to be done differently.
> 
> The PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG bit should be set via a PCI quirk
> entry in drivers/pci/quirks.c just as it is done for other devices which have this
> problem.
> 
> Thank you.

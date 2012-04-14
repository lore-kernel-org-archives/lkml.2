Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2DNKjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:39:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1135 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2DNKjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:39:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6679"; a="179409976"
X-IronPort-AV: E=Sophos;i="4.75,420,1330934400"; 
   d="scan'208";a="120359554"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH 12/37] atl1c: restore max-read-request-size in Device
 Conrol Register
Thread-Topic: [PATCH 12/37] atl1c: restore max-read-request-size in Device
 Conrol Register
Thread-Index: AQHNGQq8J6Zbpt42tE6eV9My56f0MpaZcb6AgACpWoA=
Date: Sat, 14 Apr 2012 10:39:51 +0000
Message-ID: <157393863283F442885425D2C454285623D4888F@nasanexd02a.na.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
	 <1334276102-15866-13-git-send-email-xiong@qca.qualcomm.com>
 <1334336563.2606.3.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1334336563.2606.3.camel@bwh-desktop.uk.solarflarecom.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.39.5]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3EAe1Tt023441



> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Ben Hutchings
> Sent: Saturday, April 14, 2012 1:03
> To: Huang, Xiong
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; qca-linux-team; nic-devel; linux-pci
> Subject: Re: [PATCH 12/37] atl1c: restore max-read-request-size in Device
> Conrol Register
> 
> On Fri, 2012-04-13 at 08:14 +0800, xiong wrote:
> > in some platforms, we found the max-read-request-size in Device
> > Control Register is set to 0 by (BIOS?) during bootup, this will cause
> > the
> > performance(throughput) very bad.
> > Restore it to a min-value.
> > register definition of REG_DEVICE_CTRL is refined as well.
> [...]
> 
> I'm guessing this memory-mapped register is an alias for the PCIe device control
> register.  I think you should be using pcie_set_readrq() to ensure that the final
> setting conforms to the device's Max Payload Size and system policy.
> 
You are right, I don't know there is a system function to do the right thing. I will revise it. 

Thanks
Xiong

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

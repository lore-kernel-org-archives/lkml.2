Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030677Ab2HIOe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:34:59 -0400
Received: from mxout1.idt.com ([157.165.5.25]:45826 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030423Ab2HIOe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:34:56 -0400
X-Greylist: delayed 884 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2012 10:34:56 EDT
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Don Dutile" <ddutile@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>
CC: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        "Taku Izumi" <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v3 30/32] PCI/tsi721: use PCIe capabilities access
 functions to simplify implementation
Thread-Topic: [PATCH v3 30/32] PCI/tsi721: use PCIe capabilities access
 functions to simplify implementation
Thread-Index: AQHNb/7NRmnAkzkCjUWSiOLDKW8dpJdRkqVA
Date: Thu, 9 Aug 2012 14:16:55 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D12BD2B087@corpmail1.na.ads.idt.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
 <1343836477-7287-31-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343836477-7287-31-git-send-email-jiang.liu@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sent: Wednesday, August 01, 2012 11:55 AM
> Subject: [PATCH v3 30/32] PCI/tsi721: use PCIe capabilities access
> functions to simplify implementation
> 
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Use PCIe capabilities access functions to simplify tsi721 driver's
> implementation.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/rapidio/devices/tsi721.c |   19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

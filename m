Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946115Ab2EROLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:11:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:5206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031209Ab2EROKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168113443"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Jiang Liu <liuj97@gmail.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keping Chen <chenkeping@huawei.com>
Subject: RE: [RESEND,PATCH] DCA, x86: fix invalid memory access in DCA core
Thread-Topic: [RESEND,PATCH] DCA, x86: fix invalid memory access in DCA core
Thread-Index: AQHNLGpswXPcpzMJXUaOCs7yj0xbMZbBjugAgACoiYCADSUdUA==
Date: Fri, 18 May 2012 14:10:04 +0000
Message-ID: <436EC33EF05C3442BBF5497FC9483FF4162732ED@IRSMSX101.ger.corp.intel.com>
References: <1336406288-9479-1-git-send-email-jiang.liu@huawei.com>
 <436EC33EF05C3442BBF5497FC9483FF41626EACA@IRSMSX101.ger.corp.intel.com>
 <4FAB20FB.6070508@gmail.com>
In-Reply-To: <4FAB20FB.6070508@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, May 10, 2012 3:59 AM, Jiang Liu <liuj97@gmail.com> wrote:
>
>Hi Maciej,
>	I feel we may also need to tune the multiple IOH support in DCA.
>Multiple IOH support is disabled for CB3.0 devices, how about CB3.1 devices
>in Ivrbridge or SandyBridge? Does the hardware limitation still exist? Or
>could we support multiple IOHs with IvyBridge and SandyBridge?
>	If multiple IOH is supported, I think we should move the logic to
>disable multiple IOH support for CB3.0 from DCA core into ioatdma. I have
>also prepared two patches for that two.
>	Thanks!
>

At this point I do not think we would need to tune multiple IOH for DCA.
The limitation you mention applies only to CB3.0. I do not think DCA is supported
with Sandy Bridge / Ivy Bridge regardless of multi-IOH case but let me confirm it
yet.

Thanks,
Maciej

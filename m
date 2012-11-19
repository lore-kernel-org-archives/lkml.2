Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2KSV1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:27:39 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:12140 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2KSV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:27:36 -0500
Message-ID: <1353359959.10939.84.camel@misato.fc.hp.com>
Subject: Re: [ACPIHP PATCH part1 0/4] introduce a framework for ACPI based
 system device hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mm@kvack.org,
        "Wang, Frank" <frank.wang@intel.com>
Date: Mon, 19 Nov 2012 14:19:19 -0700
In-Reply-To: <50AA63CE.9080700@gmail.com>
References: <1351958865-24394-1-git-send-email-jiang.liu@huawei.com>
	 <6684049.OOiNLWpfRL@vostro.rjw.lan> <50AA63CE.9080700@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But for the ACPI part for CPU and memory hotplug enhancements recently posted to
> the community, I think they are different solutions with the new framework. I feel
> they are lightweight enhancements to existing code with some limitations, but the
> new framework is a heavyweight solution with full functionalities and improved
> usability. So we may need discussions about the different solutions here:)

Hi Gerry,

Thanks for working on the framework enhancement.  I am still new to
Linux (and learning :), but have extensive background in hot-plug
features on other OS for CPU, Memory, Node, RP and PCI hot-plug support.
So, I basically agree with you that we do need framework enhancement.
However, I think we need phased approach here.  First, we need to make
CPU and Memory hot-plug work under the current framework.  Once we
settle on the basic features, we can then make framework enhancements
without breaking the features.  For CPU hotplug, I also intentionally
minimized the code changes so that the changes could be back-ported to
older kernels being used by distributions.

I will send you more comments after I reviewed your patches (which may
take some time :).

Thanks,
-Toshi




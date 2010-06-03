Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab0FCReZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:34:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:47545 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab0FCReX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:34:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,355,1272870000"; 
   d="scan'208";a="804479804"
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: Frank Pan <frankpzh@gmail.com>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 3 Jun 2010 11:10:38 -0600
Subject: RE: Add a helper function in PCI IOV to get VF device
Thread-Topic: Add a helper function in PCI IOV to get VF device
Thread-Index: AcsCyn3qoUdB+xVdQpayC9H2KYPqqgAdMSXA
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FF3FF358C@rrsmsx501.amr.corp.intel.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
 	<20100601183920.GB19955@kroah.com>
 <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com>
 	<AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com>
 	<EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com>
 	<AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com>
 <AANLkTilh4P9pcC53J7An3TioIPNk7LAwp9zq1R7jwiCx@mail.gmail.com>
In-Reply-To: <AANLkTilh4P9pcC53J7An3TioIPNk7LAwp9zq1R7jwiCx@mail.gmail.com>
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

>-----Original Message-----
>From: Frank Pan [mailto:frankpzh@gmail.com]
>Sent: Wednesday, June 02, 2010 8:11 PM

[snip]
>So, the motivation is provide some information about vf from pf driver by
>sysfs.
>
>I cannot avoid to create one directory for each vf, like vf0, vf1,
>etc. Although userspace can find these directories, but it has no idea
>about which one to use. Userspace just knows vf's bdf, it won't care
>about/know vf's id. So I have the issue to create a symlink from each
>vf's /sys/bus/pci/devices/xxxx/ to their corresponding directories.
>
>And then comes the issue: PF cannot get VF's bdf in kernel space.
>
>This is not a strange issue, hacking every SR-IOV device can met.
>

Frank, I still don't understand what you're trying to do here. What's the use case? What is the end goal that you're trying to get to?

What information do you need about the VF, and why?  SR-IOV works properly today without this stuff.

If we can understand what you're trying to do, then maybe we can help.

-Mitch

>Thanks.
>
>--
>Frank Pan
>
>Computer Science and Technology
>Tsinghua University

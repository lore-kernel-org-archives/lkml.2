Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2LCRmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:42:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:43885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab2LCRmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:42:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,208,1355126400"; 
   d="scan'208";a="256654590"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.kumar@linaro.org>, Dan Williams <djbw@fb.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Mason, Jon" <jon.mason@intel.com>
Subject: RE: [PATCH v2] dmatest: Fix NULL pointer dereference on ioat
Thread-Topic: [PATCH v2] dmatest: Fix NULL pointer dereference on ioat
Thread-Index: AQHNwGDJKBnb2Ushf0C5VEMqI8IyuJfoR+2AgAy+rYCAEnNhMA==
Date: Mon, 3 Dec 2012 17:42:00 +0000
Message-ID: <8D3F6266AEB6384E807C6FFC6FE195E302270D26@BGSMSX101.gar.corp.intel.com>
References: <1352675000-29627-1-git-send-email-jon.mason@intel.com>
	<CAOh2x=niXPCeg1dWtmjDjms_8ndYD7pzGY37k36e8=D8Km7gqQ@mail.gmail.com>
 <CAOh2x==rW9NNJ6kxRF13D=eYVmHsEhCHck7ecDpe9YcrSm8mXA@mail.gmail.com>
In-Reply-To: <CAOh2x==rW9NNJ6kxRF13D=eYVmHsEhCHck7ecDpe9YcrSm8mXA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 14, 2012 at 8:17 AM, viresh kumar <viresh.kumar@linaro.org> wrote:
> > On Mon, Nov 12, 2012 at 4:33 AM, Jon Mason <jon.mason@intel.com> wrote:
> >> device_control is an optional and not implemented in all DMA drivers.
> >> Any calls to these will result in a NULL pointer dereference.
> >> dmatest makes two of these calls when completing the kernel thread
> >> and removing the module.  These are corrected by calling the
> >> dmaengine_device_control wrapper and checking for a non-existant
> >> device_control function pointer there.
> >>
> >> Signed-off-by: Jon Mason <jon.mason@intel.com>
> >> CC: Vinod Koul <vinod.koul@intel.com>
> >> CC: Dan Williams <djbw@fb.com>
> 
> > Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Applied, Thanks

--
~Vinod

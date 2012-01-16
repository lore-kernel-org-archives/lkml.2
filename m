Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2APQHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:07:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:6494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab2APQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:07:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112816988"
Message-ID: <4F144B4F.7050905@linux.intel.com>
Date: Mon, 16 Jan 2012 08:07:43 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Alan Cox <alan@linux.intel.com>, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of failing
 probe
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com> <20120114.001430.787918662083526597.davem@davemloft.net> <4F11A533.4040406@linux.intel.com> <20120114.115604.2101782124431552110.davem@davemloft.net> <20120114214658.4ddfec30@pyramind.ukuu.org.uk> <4F120357.3020808@linux.intel.com> <CANKRQnge1n4M7W5xCqwyGzXp8J3eK1HbZVRqGW7BoE5iOwYCDQ@mail.gmail.com> <20120116123110.7ce91f2d@bob.linux.org.uk> <4F14457F.8060509@linux.intel.com>
In-Reply-To: <4F14457F.8060509@linux.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2012 7:42 AM, Darren Hart wrote:

> One reason I don't care for this alternative approach is that this
> particular hardware is targeted at embedded use where we can't assume a
> full init system is available, etc. It can be made to work of course, it
> just isn't as automated.
> 

the tricky thing with embedded hw like this is that all devices might
end up with the same, read-only filesystem, so storing the mac on the FS
and then loading it from there into the HW is... suboptimal.

Would be very nice if busybox had a command that would check the mac
from each IF, and created the random mac from userspace automatically...


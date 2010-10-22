Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab0JVRNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:13:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:20249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab0JVRNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,224,1286175600"; 
   d="scan'208";a="339348797"
Message-ID: <4CC1C63A.2040405@linux.intel.com>
Date: Fri, 22 Oct 2010 10:13:30 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@novell.com>, jeremy@goop.org,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: Modularizing IOMMUs (devel/iommu-0.4)
References: <20101020202006.GA30096@dumpdata.com> <4CC15EE9020000780001E8B5@vpn.id2.novell.com> <20101022135439.GA23030@dumpdata.com>
In-Reply-To: <20101022135439.GA23030@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 06:54 AM, Konrad Rzeszutek Wilk wrote:
> <nods>  It does sound like the right option. 12 years ago it was suggested,
> so.. how come nobody worked on it in the past? Were there some epic battles?

No, quite the opposite... deafening silence.  However, 12 years ago the 
module infrastructure looked very different than it does today, with 
large chunks implemented in user space.  These days the module 
infrastructure is almost entirely in the kernel, which should make it a 
lot easier to implement.

I thus suspect that it was just too hard when it was first proposed, and 
then got forgotten about.

	-hpa


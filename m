Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2AQRWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:22:32 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:47495
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908Ab2AQRW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:22:28 -0500
X-IronPort-AV: E=Sophos;i="4.71,524,1320620400"; 
   d="scan'208";a="127790204"
Date: Tue, 17 Jan 2012 18:22:26 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Vinod Koul <vinod.koul@intel.com>
cc: Dan Williams <dan.j.williams@intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/15] drivers/dma/pl330.c: add missing iounmap
In-Reply-To: <1326820459.1540.171.camel@vkoul-udesk3>
Message-ID: <alpine.DEB.2.02.1201171821530.1897@localhost6.localdomain6>
References: <1326362117-29371-4-git-send-email-Julia.Lawall@lip6.fr>  <1326819104.1540.166.camel@vkoul-udesk3>  <alpine.DEB.2.02.1201171754480.1897@localhost6.localdomain6> <1326820459.1540.171.camel@vkoul-udesk3>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jan 2012, Vinod Koul wrote:

> On Tue, 2012-01-17 at 17:55 +0100, Julia Lawall wrote:
>>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>> Acked by Vinod Koul <vinod.koul@linux.intel.com>
>>>
>>> Which tree is this intended for?
>>
>> It was generated from linux-next, although I'm not sure if that is
>> the
>> intended sense of the question.
> I meant, which tree is this intended to be merged thru?
> slave-dma or any other. Since this is patch is series, typically a
> series is applied thru a single tree. If that is not the case, then I am
> happy to apply thru slave-dma :)

There is no dependency between these patches, so I think you can do 
whatever seems best with respect to this specific change.

julia

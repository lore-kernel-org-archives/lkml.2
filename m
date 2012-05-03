Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2ECJhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:37:48 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39699 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab2ECJhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:37:46 -0400
Message-ID: <4FA251B5.8080109@linux.vnet.ibm.com>
Date: Thu, 03 May 2012 15:06:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpoirier@suse.de,
        jeffrey.t.kirsher@intel.com, rjw@sisk.pl, linux-pm@vger.kernel.org,
        stephen.s.ko@intel.com
Subject: Re: [GIT] Networking
References: <20120503.025951.1393913795357644010.davem@davemloft.net> <4FA24AB1.9010108@linux.vnet.ibm.com> <20120503.053246.92708809581536438.davem@davemloft.net>
In-Reply-To: <20120503.053246.92708809581536438.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050309-5816-0000-0000-00000265065E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 03:02 PM, David Miller wrote:

> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Date: Thu, 03 May 2012 14:36:57 +0530
> 
>> https://lkml.org/lkml/2012/4/5/197
> 
> Networking patches not posted to netdev and the Intel ethernet driver
> maintainers will be ignored.
> 


Jeff Kirsher (Intel ethernet driver maintainer) already acked that
patchset (both patches).

https://lkml.org/lkml/2012/4/5/376
https://lkml.org/lkml/2012/4/5/377

One went upstream, the other didn't (yet). That's my concern.

Regards,
Srivatsa S. Bhat


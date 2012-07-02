Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2GBQIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:08:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41385 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2GBQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:08:35 -0400
Message-ID: <4FF1C780.9020003@wwwdotorg.org>
Date: Mon, 02 Jul 2012 10:08:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] regulator: fixed: support deferred probe for DT GPIOs
References: <1340987595-11288-1-git-send-email-swarren@wwwdotorg.org> <20120701182300.GE28922@opensource.wolfsonmicro.com> <4FF1C0D6.3010108@wwwdotorg.org> <20120702160340.GG25093@opensource.wolfsonmicro.com>
In-Reply-To: <20120702160340.GG25093@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 10:03 AM, Mark Brown wrote:
> On Mon, Jul 02, 2012 at 09:40:06AM -0600, Stephen Warren wrote:
>> On 07/01/2012 12:23 PM, Mark Brown wrote:
> 
>>> ...this just seems rubbish, why aren't we just fixing the
>>> device tree code and why are we doing this at the device tree
>>> level rather than as a general gpiolib thing?
> 
>> It is being fixed in the DT code:
> 
>> https://lkml.org/lkml/2012/6/18/468
> 
> Is that patch actually being applied (especially with Grant's free
> time issues)?  I've still got the patch sitting in my inbox since
> it wasn't clear what was going on.

It sounds like Rob Herring will be helping out on this for a few
weeks; see:

https://lkml.org/lkml/2012/7/2/3
"Re: SPI, GPIO, and DT maintainer ship (cry for help)"

I cc'd Grant and Rob to make sure.

>> However, it seemed best to make the regulator code work both
>> before and after that patch.
> 
> I'd be kind of inclined to just leave it broken to be honest rather
> than having a huge comment and dodgy code.

Hmmm. That would have made it kinda hard to use:-(

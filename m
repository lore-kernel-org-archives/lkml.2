Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2JIGu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:50:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1515 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2JIGuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:50:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 08 Oct 2012 23:50:20 -0700
Message-ID: <5073C13B.1070605@nvidia.com>
Date: Tue, 9 Oct 2012 11:46:27 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] regulator; tps65090: Register all regulators in single
 probe call
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com> <1349536671-31714-4-git-send-email-ldewangan@nvidia.com> <20121009062231.GI8237@opensource.wolfsonmicro.com>
In-Reply-To: <20121009062231.GI8237@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012 11:52 AM, Mark Brown wrote:
> On Sat, Oct 06, 2012 at 08:47:48PM +0530, Laxman Dewangan wrote:
>> MFD drier registers the regulator driver once per device and
> Shouldn't this be the first commit in the series?  Also...

Ok, will make this as first commit.

>
> to allow things to be missed out.  Otherwise we're likely to crash if
> the user misses a regulator or something.

Agree with your suggestion and for this either I need to move all the 
defs of regulator/tps65090-regulator.h  to mfd/tps65090.h  or include 
the regulator header in mfd header.
I will move all this to the mfd header and get rid of regulator header.

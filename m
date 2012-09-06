Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2IFXFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:05:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34283 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2IFXFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:05:50 -0400
Message-ID: <50492C4B.6010502@wwwdotorg.org>
Date: Thu, 06 Sep 2012 17:05:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4] regulator: tps6586x: add support for SYS rail
References: <1346791419-31290-1-git-send-email-swarren@wwwdotorg.org> <20120906000136.GM10580@opensource.wolfsonmicro.com>
In-Reply-To: <20120906000136.GM10580@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 06:01 PM, Mark Brown wrote:
> On Tue, Sep 04, 2012 at 02:43:39PM -0600, Stephen Warren wrote:
>> From: Laxman Dewangan <ldewangan@nvidia.com>
>>
>> Device have SYS rail which is always ON. It is system power bus. LDO5
>> and LDO_RTC get powered through this rail internally. Add support for
>> this rail and make the LDO5/LDO_RTC supply by it. Update document
>> accordingly.
> 
> Applied, thanks.  It'll be next week before I can give you a signed tag
> to pull, sorry.

Thanks. For the record, as I mentioned on IRC, I've merged the topic
branch that contains this patch into the Tegra tree. As soon as you have
a tag available, I'll pull that in instead, and rebase on it.

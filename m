Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2HBRL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:11:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51690 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab2HBRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:11:24 -0400
Message-ID: <501AB4B9.5030805@wwwdotorg.org>
Date: Thu, 02 Aug 2012 11:11:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: add MAX8907 core driver
References: <1343854085-29663-1-git-send-email-swarren@wwwdotorg.org> <20120802161544.GE4537@opensource.wolfsonmicro.com>
In-Reply-To: <20120802161544.GE4537@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 10:15 AM, Mark Brown wrote:
> On Wed, Aug 01, 2012 at 02:48:05PM -0600, Stephen Warren wrote:
>> From: Gyungoh Yoo <jack.yoo@maxim-ic.com>
>>
>> The MAX8907 is an I2C-based power-management IC containing voltage
>> regulators, a reset controller, a real-time clock, and a touch-screen
>> controller.
> 
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks very much.

Samuel, please don't apply this just yet though - it looks like I need
to make some minor changes to the header file and DT binding
documentation to add in a definition for one more regulator. I'll repost
the amended version along with the regulator driver later.

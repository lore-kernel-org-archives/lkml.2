Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2H1UKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:10:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:50610 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab2H1UKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:10:04 -0400
Message-ID: <503D2599.6090206@slimlogic.co.uk>
Date: Tue, 28 Aug 2012 22:10:01 +0200
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com
Subject: Re: [PATCH 2/6] mfd: palmas switch to linear domain in all cases
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk> <1346154460-20031-3-git-send-email-gg@slimlogic.co.uk> <20120828181100.GA8796@opensource.wolfsonmicro.com>
In-Reply-To: <20120828181100.GA8796@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/12 20:11, Mark Brown wrote:
> On Tue, Aug 28, 2012 at 01:47:36PM +0200, Graeme Gregory wrote:
>> Swith the palmas to linear domain in all cases so in future DT and non
>> DT cases will work the same.
>> With this change we can not use regmap_get_virq internally so no need
>> to supply IRQ resources to children so remove those definitions.
> This second bit of the comment doesn't follow - regmap_get_virq() works
> with any kind of irqdomain.
Ill re-word it then, I basically meant that the resources are not needed
as internally its easier to use regmap_get_virq().

Graeme


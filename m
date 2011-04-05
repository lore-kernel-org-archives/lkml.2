Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1DEGZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:25:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42995 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1DEGZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:25:49 -0400
Message-ID: <4D9AB5E8.3080401@monstr.eu>
Date: Tue, 05 Apr 2011 08:25:44 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
References: <20110331124925.GA2202@pengutronix.de> <4D948189.9070606@monstr.eu> <20110331170321.GA2734@local> <4D94C09B.4070506@monstr.eu> <20110331192302.GD2734@local> <AANLkTin6iSVQtKo602hceod+4=cVUMG=GR7cCZvHg4nO@mail.gmail.com> <20110331203024.GE2734@local> <20110402103550.GA21760@pengutronix.de> <20110404170437.GA4830@local> <20110404173149.GB12200@pengutronix.de> <20110404182423.GC4830@local>
In-Reply-To: <20110404182423.GC4830@local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans J. Koch wrote:
> On Mon, Apr 04, 2011 at 07:31:49PM +0200, Wolfram Sang wrote:
>> So, the solution for now is to simply add a default value and we can check
>> later if it can be modified at runtime?
> 
> Yes.

ok. Nice. What default value would you like to see as the version string?
'0', 'generic', 'generic-uio', 'dt'

Ok the last thing is how to handle compatible property.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab1CCTgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:36:15 -0500
Received: from antcom.de ([188.40.178.216]:39580 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab1CCTgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:36:14 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Mar 2011 14:36:14 EST
Message-ID: <4D6FEB74.7050503@antcom.de>
Date: Thu, 03 Mar 2011 20:26:44 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101110 Iceowl/1.0b2 Icedove/3.1.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, info@pengutronix.de
Subject: Re: [PATCH] max730x: Added setup/teardown hooks
References: <1297425606-13290-1-git-send-email-stigge@antcom.de> <AANLkTimUd1WQ2G0W0D0DLt+-bvdwxw9aZx6tgjno8ym=@mail.gmail.com>
In-Reply-To: <AANLkTimUd1WQ2G0W0D0DLt+-bvdwxw9aZx6tgjno8ym=@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 07:59 PM, Grant Likely wrote:
> On Fri, Feb 11, 2011 at 5:00 AM,  <stigge@antcom.de> wrote:
>> max730x: Added setup/teardown hooks
>>
>> This patch adds setup and teardown hooks for configuration of GPIO lines via
>> platform_data, similar to the pca953x driver.
> 
> Why?  What actions are these hooks going to perform?

In board configurations, ARM systems are set up with GPIO lines
configured as Input or Output etc. See also arch/arm/*/*. See usage of
pca953x - how it is already done there.

Thanks,

Roland

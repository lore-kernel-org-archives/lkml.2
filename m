Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1D1LH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:07:57 -0400
Received: from smtp.nokia.com ([147.243.1.47]:20536 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab1D1LHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 07:07:55 -0400
Message-ID: <4DB94A70.3060009@nokia.com>
Date: Thu, 28 Apr 2011 14:07:28 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.18) Gecko/20110320 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: kalle.jokiniemi@nokia.com, lrg@slimlogic.co.uk, mchehab@infradead.org,
        svarbatov@mm-sol.com, saaguirre@ti.com, grosikopulos@mm-sol.com,
        vimarsh.zutshi@nokia.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Regulator state after regulator_get
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com> <4DB9348D.7000501@nokia.com> <9D0D31AA57AAF5499AFDC63D6472631B09C7BE@008-AM1MPN1-036.mgdnok.nokia.com> <20110428102009.GB14494@opensource.wolfsonmicro.com> <4DB94122.9010203@nokia.com> <20110428104021.GD14494@opensource.wolfsonmicro.com>
In-Reply-To: <20110428104021.GD14494@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Apr 28, 2011 at 01:27:46PM +0300, Sakari Ailus wrote:
>> Mark Brown wrote:
> 
>>> I'm not sure what "supply_nasty" would mean?  This also doesn't seem
>>> like something that we can set up per supply - it's going to affect the
>>> whole regulator state, it's not something that only affects a single
>>> supply.
> 
>> supply_nasty() would be used to define a regulator which is enabled by
>> the boot loader when it shouldn't be, which is the actual problem.
> 
> That's *really* not a clear name.

I agree. It was just meant to imply that there's something wrong in the
way it behaves. :-)

>> How should this regulator be turned off in the boot by the kernel?
> 
> Have you read my previous mail where I described the existing support
> for doing this when we have a full set of information on the regualtors
> in the systems?

Yes, I did read it but I first understood that this use case wasn't
supported right now. Having read it again, that's clearly the way to go
with fixing this. Thanks.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

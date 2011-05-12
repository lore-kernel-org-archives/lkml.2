Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1ELJUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:20:33 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:30635 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab1ELJUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:20:32 -0400
Message-ID: <4DCBA656.3060608@atmel.com>
Date: Thu, 12 May 2011 11:20:22 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: pause: no need to wait for FIFO
 empty
References: <be7d19459501aaa604aebe91daa9e9e59bb41c86.1304704588.git.nicolas.ferre@atmel.com>	 <1304957497-22814-1-git-send-email-nicolas.ferre@atmel.com> <1305188936.28926.66.camel@vkoul-udesk3>
In-Reply-To: <1305188936.28926.66.camel@vkoul-udesk3>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/05/2011 10:28, Koul, Vinod :
> On Mon, 2011-05-09 at 18:11 +0200, Nicolas Ferre wrote:
>> The addition of the pause feature to atc_control an active wait was introduced
>> to check the FIFO empty event. This event was not always happening and
>> a timout contition was needed.
>> But, in some cases, this event depend on the peripheral connected to the
>> channel that is paused: FIFO becomes empty if the peripheral consumes data.
>> The timeout is pretty difficult to evaluate. Moreover, this check is not
>> needed.
>> In conclusion, it seems sensible to entirely remove the checking of
>> "FIFO empty" status when pausing.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> Vinod,
>>
>> This additional patch goes on top of your current "next" branch. It is a
>> removing of some code added to the pause/resume patch sent earlier and can be
>> folded into this one if you want to.
>>
> Applied with edit in commit msg, Thanks

Thanks a lot.

Bye,
-- 
Nicolas Ferre


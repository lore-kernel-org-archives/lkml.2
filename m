Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1EJMFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:05:14 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:54520 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab1EJMFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:05:13 -0400
Message-ID: <4DC929EC.6040706@atmel.com>
Date: Tue, 10 May 2011 14:05:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>, vinod.koul@intel.com
CC: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: pause: no need to wait for FIFO
 empty
References: <be7d19459501aaa604aebe91daa9e9e59bb41c86.1304704588.git.nicolas.ferre@atmel.com> <1304957497-22814-1-git-send-email-nicolas.ferre@atmel.com> <4DC927DF.1060808@ru.mvista.com>
In-Reply-To: <4DC927DF.1060808@ru.mvista.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 10/05/2011 13:56, Sergei Shtylyov :
> Hello.
> 
> On 09-05-2011 20:11, Nicolas Ferre wrote:
> 
>> The addition of the pause feature to atc_control an active wait was
>> introduced
>> to check the FIFO empty event.
> 
>    Couldn't parse this -- did you forget "with"at the start of the
> statement?

Absolutely. A comma can also improve things... is it better like this?

"
With the addition of the "pause" feature, an active wait loop was
introduced to check the "FIFO empty" event.
"

Vinod, tell me if you want me to send a new patch.

>> This event was not always happening and
>> a timout contition was needed.
>> But, in some cases, this event depend on the peripheral connected to the
>> channel that is paused: FIFO becomes empty if the peripheral consumes
>> data.
>> The timeout is pretty difficult to evaluate. Moreover, this check is not
>> needed.
>> In conclusion, it seems sensible to entirely remove the checking of
>> "FIFO empty" status when pausing.
> 
>> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
> 
> WBR, Sergei

Thanks, best regards,
-- 
Nicolas Ferre


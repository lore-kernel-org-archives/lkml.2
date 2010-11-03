Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0KCKJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:09:10 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:33680 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab0KCKJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:09:09 -0400
Message-ID: <4CD13492.9030900@euromail.se>
Date: Wed, 03 Nov 2010 11:08:18 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: gimli <gimli@dark-green.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] MacBookAir3,1(3,2) hid support
References: <799cfececb18800d63df64fc93e2228f@mognix.dark-green.com> <4CD0427F.4050804@euromail.se> <33a056946badf540124631f517eef199@mognix.dark-green.com>
In-Reply-To: <33a056946badf540124631f517eef199@mognix.dark-green.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PDaGT-0001sp-Ay.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PDaGT-0001sp-Ay 3982a52dd1cbbee8a29ff847b58e692f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 10:41 AM, gimli wrote:

> On Tue, 02 Nov 2010 17:55:27 +0100, Henrik Rydberg <rydberg@euromail.se>
> wrote:
>> On 11/02/2010 08:20 AM, gimli wrote:
>>
>>> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
> hid
>>> driver.
>>>
>>> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
>>>
>>
>>
>> Hi Edgar,
>>
>> thanks for the information. Are the device ids correlated to the 13'' and
>> 11''
>> versions of these machines? If so, why are they mapped to the same
>> keyboard? The
>> apple_fn_keys also covers the existing Macbook Airs, but appears not to
> be
>> used
>> for any of the new device ids.
> 
> The keyboard layout changed on the new Air's. Thats the reason why i use
> a new apple_fn_keys for the new Air's.


Thanks for the clarification, it all makes sense.

Did you consider using quirks for the keyboard layouts instead? Either way,

Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1DDJiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:38:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44335 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1DDJiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qoE0w1tmcKkt+Zb1r0OQhCZW1Wdh8QhJYPJjZq94JkrirSWjCIOa+sMdgjLvCIPI4P
         I301nu5PNIrZUYA4O8hjUVdvGYHfY2R6jxeaA7Qhj2huTZijptWTFkopXO9gY4HAvERB
         eBFe79OPSYAVcV4w4m7jDsWpA0fUsv7FSrtwI=
Message-ID: <4D999177.4010401@vexillium.org>
Date: Mon, 04 Apr 2011 10:37:59 +0100
From: Unavowed <unavowed@vexillium.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add NOGET quirk for the CH Pro Throttle
References: <4d988b60.29c6ec0a.0716.ffffa4bf@mx.google.com> <alpine.LNX.2.00.1104041105250.28516@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1104041105250.28516@pobox.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/11 10:05, Jiri Kosina wrote:
> On Sun, 3 Apr 2011, Unavowed wrote:
> 
>> The CH Pro Throttle needs the NOGET quirk flag to work, just like other CH
>> Products devices which already have the flag set.
>>
>> Signed-off-by: Unavowed <unavowed@vexillium.org>
> 
> Hi,
> 
> thanks a lot for the patch.
> 
> Would it please be possible to have a real name to attribute for patch 
> authorship and Signed-off-by line?

Hi,

Thanks for such a quick response.

I'm sorry, but I only ever write contributions under a pseudonym.  Is
this not acceptable, especially for such a trivial patch?
-- 
Unavowed

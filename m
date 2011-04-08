Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1DHJYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:24:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64416 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1DHJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xUIlmNDaTM2Cm6lrDKfhH2xD92rO6gMgLF2WktI0K07vyUeQkBEz33KCbU8YwGkVj0
         XNvAmIe5L8m9fegcWAZMR2n/6FU+Eci0gRMi88g2j87r8xc8SiiLDyNBOd5o6rJlxPDP
         j01CMlzgfVUk6WbSIDSXTnW8UFIi+c8B8b5FY=
Message-ID: <4D9ED443.6040206@vexillium.org>
Date: Fri, 08 Apr 2011 10:24:19 +0100
From: Unavowed <unavowed@vexillium.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add NOGET quirk for the CH Pro Throttle
References: <4d988b60.29c6ec0a.0716.ffffa4bf@mx.google.com> <alpine.LNX.2.00.1104041105250.28516@pobox.suse.cz> <4D999177.4010401@vexillium.org> <alpine.LNX.2.00.1104041340080.28516@pobox.suse.cz> <4D9B3639.80205@vexillium.org> <alpine.LNX.2.00.1104060712560.5855@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1104060712560.5855@pobox.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/11 15:17, Jiri Kosina wrote:
>> I, and probably other flight sim fans running Linux, would be very happy
>> if someone could fix write a patch fixing this.
> 
> I thought you'd figure that out :) Thanks for the report, I have queued 
> the fix in my tree.

Great, thanks.

>> And if I may comment on that "no pseudonyms" policy, I don't fully
>> understand the motivation behind it.  After all, there have been many
>> authors of copyrighted works who created them without revealing their
>> real name[1].  Is this something to please the lawyers of Linux's
>> corporate overlords?
> 
> I guess this would be topic for a separate thread, but anyway ... but I 
> believe you'd be able to dig much information from reading the threads 
> where entity calling itself 'Shem Multinymous' tried to submit Thinkpad 
> Embedded Controller drivers.
> 
> It basically defeats the Developer's Certificate of Origin process 
> completely.

Thanks for the reference, I'll remember it the next time I consider
writing a patch.
-- 
Unavowed

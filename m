Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1FCHP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:15:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40926 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1FCHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YrdlBHQQLeXcZy0E/7AzXLcw+DVClw8lHu/qqzqS70gp2fpWBoUMl4TwXjzg3TcYfT
         +kJR5PHSSnHbCEK9agKDd0jpI6cIu21QVQSYCQ667C8yKs70J4geKS7SmcfIbaplodZz
         40JAtfQSPR/nQZXXBY40VTfP1TuLj7W6q8qgE=
Message-ID: <4DE88A25.2040300@suse.cz>
Date: Fri, 03 Jun 2011 09:15:49 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: lists+linux-kernel@corpit.ru
CC: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        James.Bottomley@HansenPartnership.com, Jens Axboe <axboe@kernel.dk>,
        greg@kroah.com, stable@kernel.org, jejb@parisc-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
References: <20110511193451.GC26010@kroah.com>	<20110519002505.GB8697@kroah.com>	<1305776367.2576.0.camel@mulgrave.site> <20110601.213424.80025869.anemo@mba.ocn.ne.jp> <4DE886D1.8090807@msgid.tls.msk.ru> <4DE888BB.8000008@msgid.corpit.ru>
In-Reply-To: <4DE888BB.8000008@msgid.corpit.ru>
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 09:09 AM, lists+linux-kernel@corpit.ru wrote:
> 03.06.2011 11:01, Michael Tokarev wrote:
>> commit 2e8532e0a9ee1d25b279ac78ee8ce31701e2aa15
>> Author: Michael Tokarev <mjt@tls.msk.ru>
>> Date:   Fri Jun 3 10:50:49 2011 +0400
>>
>>     block: add proper state guards to elv_queue_empty()
>>
>>     Like in 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae (backported to
>>     stable 2.6.38 as 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae) which
>>     fixes this for __elv_next_request(), as reported by Atsushi Nemoto,
>>     elv_queue_empty() also needs to check for dead queue condition
>>     before touchin elevator.
>>
>>     elv_queue_empty() has been removed upstream so this is only applicable
>>     for versions prior to 2.6.39, including 2.6.32-longterm.
> 
> Um, i'm not sure about this one -- 2.6.32 does not have
> other pieces of this puzzle (and 2.6.38.8 was the last
> in the 2.6.38.y series).

And what about .33 and .34 which are longterm too? Does this apply to them?

thanks,
-- 
js
suse labs

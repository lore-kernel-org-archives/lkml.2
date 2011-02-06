Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1BFNQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:16:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64437 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1BFNQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:16:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iPmrekR8rRUJivVR+Nzk/Ent/EgLIg4OsZP/BisxJNVdWiBW27UO3XbGr02CHg6gNN
         rmczwmWILCxw3P+h6qzfOf37EMs+RnfjAf28aGUWTzVFvSviwmTJ1ZkCQ01gETKmNpE+
         UlLPkhDjFXC15NRoV2poM0SRFdAgW1o6TViko=
MIME-Version: 1.0
In-Reply-To: <4D4DAF75.5090607@vflare.org>
References: <4D4D95C6.20505@vflare.org>
	<4D4DAF75.5090607@vflare.org>
Date: Sun, 6 Feb 2011 22:16:06 +0900
Message-ID: <AANLkTi=GhnOPxhvV87P3NTA-nES3zjxcTgSQjHQFC-w8@mail.gmail.com>
Subject: Re: zcache and kztmem combine to become the new zcache
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 5:13 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> (Sorry, forgot to CC Dan)
>
> On 02/05/2011 01:24 PM, Nitin Gupta wrote:
>>
>> To zcache and kztmem users/reviewers --
>>
>> We, Nitin and Dan, have decided to combine zcache and kztmem and
>> call the resulting work as zcache.
>>
>> Since kztmem has evolved further than zcache, we have agreed to
>> use the kztmem code as the foundation for future work, so Dan will
>> resubmit the kztmem patchset soon with the name changed to zcache.
>>
>> Since both the "old zcache" and "new zcache" depend on the proposed
>> cleancache patch, Nitin and Dan will jointly work with the Linux
>> maintainers to support merging of cleancache, and also work together
>> on possibilities for merging frontswap and zram, since they serve
>> a similar function.
>>
>> If you have any questions or concerns, please ensure you reply
>> to both of us.
>>
>> Nitin Gupta and Dan Magenheimer

Good to hear! and sorry for not giving the time to review it recently.
I am looking forward to seeing the feature. :)

Thanks.


-- 
Kind regards,
Minchan Kim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab0CSN3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 09:29:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:44625 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab0CSN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 09:29:17 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Mar 2010 09:29:17 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RuzCSqFg11zK2hdgtkIIPPSxpwu5yj4zisVntdBBgCIxaVPGYiUDBinTMAJWrYxPfO
         HynP8QH0B3SQ4Ccf3ECn0VinoIzLq6SsP1tw1f+cZ3txCykCzJHOXNEbUGQYNwJqfyvO
         iNgINVI5lExSugzfdn52dke37e7m1++h7LVcA=
Message-ID: <4BA37AE2.5040800@gmail.com>
Date: Fri, 19 Mar 2010 06:23:46 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a typo in sound/pci/hda/hda_local.h
References: <1268965573-11829-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1003191053120.18642@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1003191053120.18642@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 02:53 AM, Jiri Kosina wrote:
> On Thu, 18 Mar 2010, Justin P. Mattock wrote:
>
>> I think this should be automatic pin instead of ping.
>> (but could be wrong).
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> ---
>>   sound/pci/hda/hda_local.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
>> index 7cee364..7a97f12 100644
>> --- a/sound/pci/hda/hda_local.h
>> +++ b/sound/pci/hda/hda_local.h
>> @@ -361,7 +361,7 @@ struct hda_bus_unsolicited {
>>   };
>>
>>   /*
>> - * Helper for automatic ping configuration
>> + * Helper for automatic pin configuration
>>    */
>
> Applied, thanks Justin.
>

ahh.. so it is pin
your welcome.

Justin P. Mattock

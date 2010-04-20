Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0DTRN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:13:58 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:51462 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0DTRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=D27xDEoctRmaCLyreM/gonCWAskUTY4ONdIrlI452yV36BuIakYCsQROt9hra/URaN
         77e9/JrNIRgk1Whe5q7QJFPn8QBNOWKGEzjrjeFatq7eSfnkjJcQHG/bPG5BcZ5DcC86
         YLvqkJs2LiX0ouWc80Z792u5TdUP/g3tdU0J8=
Message-ID: <4BCDE0DA.5070908@gmail.com>
Date: Tue, 20 Apr 2010 10:14:02 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix typo in percpu.h
References: <1271703076-4395-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1004201638090.7579@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1004201638090.7579@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 07:38 AM, Jiri Kosina wrote:
> On Mon, 19 Apr 2010, Justin P. Mattock wrote:
>
>> Fix a typo in arch/x86/include/asm/percpu.h
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   arch/x86/include/asm/percpu.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
>> index 66a272d..9899afa 100644
>> --- a/arch/x86/include/asm/percpu.h
>> +++ b/arch/x86/include/asm/percpu.h
>> @@ -105,7 +105,7 @@ do {							\
>>
>>   /*
>>    * Generate a percpu add to memory instruction and optimize code
>> - * if a one is added or subtracted.
>> + * if one is added or subtracted.
>>    */
>
> Applied, thanks.
>

your welcome.

Justin P. Mattock

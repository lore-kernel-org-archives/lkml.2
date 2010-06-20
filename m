Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0FTDoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 23:44:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44980 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0FTDoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 23:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XYlOMWv7URy0uZDV62Ynpva1sbB3Cazy/nxtFHv0JA0i5Q4T2cWH59cCZ7EUdi9eYT
         3i8lON9TUKKtPHZklJUlVRvu5H8eeXJZKwg92xVM2I/l/tcw+vgZZ2tdsCQ1OeA+r2Ur
         pphTB8rRyx8zmwEwh3LMh+XSn1uC5czapg0Rs=
Message-ID: <4C1D8E95.9040009@gmail.com>
Date: Sat, 19 Jun 2010 20:44:21 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeff Layton <jlayton@samba.org>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       linux-cifs@vger.kernel.org
Subject: Re: [PATCH]MAINTAINERS update e-mail address
References: <1276981011-25092-1-git-send-email-justinmattock@gmail.com> <20100619202831.042adeaf@tlielax.poochiereds.net>
In-Reply-To: <20100619202831.042adeaf@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2010 05:28 PM, Jeff Layton wrote:
> On Sat, 19 Jun 2010 13:56:51 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> get_maintainer.pl did it's job.. just the MAINTAINERS
>> file need to be updated or else you get this:
>> subject:Auto-response for your message to the "linux-cifs-client" mailing list
>>
>> The linux-cifs-client@lists.samba.org mailing list is now deprecated.
>> The new mailing list is linux-cifs@vger.kernel.org. Subscription is no
>> longer required to post to that list. Please resend your message
>> there.
>>
>> so update the linux-cifs address in the MAINTAINERS file.
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   MAINTAINERS |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 6d119c9..8d6a3ff 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1581,7 +1581,7 @@ F:	include/linux/coda*.h
>>
>>   COMMON INTERNET FILE SYSTEM (CIFS)
>>   M:	Steve French<sfrench@samba.org>
>> -L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
>> +L:	linux-cifs@vger.kernel.org	
>>   L:	samba-technical@lists.samba.org (moderated for non-subscribers)
>>   W:	http://linux-cifs.samba.org/
>>   Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
>
>
> Thanks. I sent a patch to update this a week or two ago, but it hasn't
> made it into mainline yet. I believe Steve F. is going to push the
> patch there.
>


alright cool..

Justin P. Mattock

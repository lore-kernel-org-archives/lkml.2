Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0DWHPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 03:15:22 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:33458 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0DWHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 03:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HZVvs9xtC7SBDCNwkQLP0zTB2fsNn3cTzJEBgCNgy+M2SvwaO85qxyfZCtSDQlbZM5
         Wd5lazslOF9NYX4Oi28tdKDTF8vH1xGKiSGbNChbpcapHhkk7J9fbKJx+D6GN+BLtpVp
         khOC5HvoCCGuTHaJfdQye7HAAtwQYLsKFaHFg=
Message-ID: <4BD14904.3050508@gmail.com>
Date: Fri, 23 Apr 2010 09:15:16 +0200
From: Roel Van Nyen <roel.vannyen@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Bartlomiej Zolnierkiewicz devel@driverdev.osuosl.org" 
	<bzolnier@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: fix coding style errors of r8180_rtl8225z2.c
References: <4BD0C19F.3030809@gmail.com> <20100422220726.GA23095@suse.de>
In-Reply-To: <20100422220726.GA23095@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> On Thu, Apr 22, 2010 at 11:37:35PM +0200, Roel Van Nyen wrote:
>   
>> Fix coding style errors
>>
>> Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
>>
>> ---
>>
>>  drivers/staging/rtl8187se/r8180_rtl8225z2.c |   58 ++++++++++++++-------------
>>
>>  1 files changed, 30 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
>>
>> index 6edf5a4..9c38b3a 100644
>>
>> --- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
>>
>> +++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
>>     
>
> Very wierd, your email client doubled all of the lines.
>
> Did you use git send-email to send this patch, or did you cut-and-paste
> into gmail?  If the latter, please don't :)
>
> thanks,
>
> greg k-h
>   

Hi
I used thunderbird with the instructions provided by Documentation/email-clients.txt but I probably have missed something, I will try resending with git send-email.

thanks,
Roel


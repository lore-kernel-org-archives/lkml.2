Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab0JCNje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:39:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36926 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0JCNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kSWQNE1AQCiB4hsh8r36oME4lYzyn0rAxXtyCPbgfV2QZyHyTPLfEnTP7cXa4f1/Cv
         7Vr7IAJr8kMn5ayR0RTNMp5R0i2Iae9bQMyb10QpCyobQ7pupcwJwgprrA0bcDyPq/6K
         lQnzrzRyqLYuk9TB5LvN/9Oo89byyVxO4l3D0=
MIME-Version: 1.0
In-Reply-To: <4CA87A47.6030007@bfs.de>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
	<1286037489-28439-11-git-send-email-tdent48227@gmail.com>
	<4CA87A47.6030007@bfs.de>
Date: Sun, 3 Oct 2010 09:39:31 -0400
Message-ID: <AANLkTi=MohCHAZrwoVGauP2w8kRBrXd_Yrc+6pQg8j0+@mail.gmail.com>
Subject: Re: [PATCH v3 11/20] Staging: rtl8192su: Makefile: cleaned up
 Makefile cflag lines
From: T Dent <tdent48227@gmail.com>
To: wharms@bfs.de
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/10, walter harms <wharms@bfs.de> wrote:
>
>
> Tracey Dent schrieb:
>> Changed to use the proper ccflags-y option
>>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>> ---
>>  drivers/staging/rtl8192su/Makefile |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8192su/Makefile
>> b/drivers/staging/rtl8192su/Makefile
>> index 7133894..1120c04 100644
>> --- a/drivers/staging/rtl8192su/Makefile
>> +++ b/drivers/staging/rtl8192su/Makefile
>> @@ -1,12 +1,12 @@
>>  NIC_SELECT = RTL8192SU
>>
>> -EXTRA_CFLAGS += -std=gnu89
>> -EXTRA_CFLAGS += -O2
>> +ccflags-y := -std=gnu89
>> +ccflags-y += -O2
>>
>
>
> I still do not think that -O2 belongs here.
> it should simply be removed.

True it should, but all i did was change the EXTRA_CFLAGS to ccflags-y.

>
> re,
>  wh
>
>
>
>> -EXTRA_CFLAGS += -DJACKSON_NEW_RX
>> -EXTRA_CFLAGS += -DTHOMAS_BEACON
>> +ccflags-y += -DJACKSON_NEW_RX
>> +ccflags-y += -DTHOMAS_BEACON
>>
>> -#EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
>> +#ccflags-y += -DMUTIPLE_BULK_OUT
>>
>>  r8192s_usb-objs :=		\
>>  	r8192U_wx.o		\
>


            TD

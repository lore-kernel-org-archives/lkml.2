Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab1ELMRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:17:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55157 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1ELMRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MPl42lL2dltpAw3P3s7YIByqFHLewp1TAcxqAG8pLF4z/0nKcxqZzRj/DLzsuy5Fd+
         lZYSOy4FKe9MBfSJd02rEppG0oCh3kGC0VBbin4QH+9XrQuM7Kc5QegNjxZEQ5/dhkR0
         vZL2lz6ojSWQ0IC0oFk6GJfLulRsoJfYOCRTw=
MIME-Version: 1.0
In-Reply-To: <1300787404.8008.116.camel@groo>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
 <AANLkTimTfOyhDR6BsHD_1VvzOPGbYqo6L784wPkQMi_8@mail.gmail.com> <1300787404.8008.116.camel@groo>
From: Govindraj <govindraj.ti@gmail.com>
Date: Thu, 12 May 2011 17:47:28 +0530
Message-ID: <BANLkTincpt8ojK8icvXz4XfkWL9z87VmUA@mail.gmail.com>
Subject: Re: [RFC PATCHv4 0/7] HSI framework and drivers
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        pawel.szyszuk@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 3:20 PM, Carlos Chinea <carlos.chinea@nokia.com> wrote:
> Hi,
>
> On Mon, 2011-03-21 at 09:16 +0100, ext Linus Walleij wrote:
>> 2010/12/14 Carlos Chinea <carlos.chinea@nokia.com>:
>>
>> > Here you have the fourth round of the HSI framework patches.
>>
>> I'd like to notify that this out-of-tree framework is also in use for
>> the ST-Ericsson
>> Ux500s, and we've had great success with it. You can add my:
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>

Hi Carlos,

Will you posting a next version of HSI framework.

I am planning to adapt omap-hsi driver to this framework.

--
Thanks,
Govindraj.R


> Thanks I will add the Ack to the next round of patches.
>
> We are currently working on the hsi_char module. Apart from addressing
> the comments from Alan,  we are planning to drop also the non-blocking
> support from it. The current version is not fully honoring the
> non-blocking behavior.
>
>> Possibly some ST-Ericsson people can add Tested-by tags as well.
>>
>> We will integrate Ux500 support whenever it's suitable, either after the merge
>> or as add-on patches for Carlos patch series. (If Carlos would like to keep
>> them in his series.)
>>
>
> Either way is fine, for me. Could you send the patches for review ?
>
> Br,
> Carlos
> --
> Carlos Chinea <carlos.chinea@nokia.com>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

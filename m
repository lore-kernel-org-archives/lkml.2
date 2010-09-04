Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0IDP47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 11:56:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40109 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab0IDP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 11:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KyKqRT6+xYc4pLQXLoMStfMVfBYi2z1BB4zn8BXIkyghEQ9IYETzGSG83tncmOXvKh
         EJbAEis1eQZNztAax4aehLOjzf7Dj5/Ew+/yHfToERPony8X2Lbo8fvKiz7fMCsrh7CA
         Wb4HQg9b3ClX971/WB2ExVTSURvs0ytZtl7Tg=
Message-ID: <4C826C65.4070705@gmail.com>
Date: Sat, 04 Sep 2010 08:57:25 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/28]Documentation/fb/framebuffer.txt update web address.
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com> <1279687926-29360-13-git-send-email-justinmattock@gmail.com> <AANLkTi=VUqpZywUMzwp83BvaOyqobYSqpm6qp6AiK=ZE@mail.gmail.com>
In-Reply-To: <AANLkTi=VUqpZywUMzwp83BvaOyqobYSqpm6qp6AiK=ZE@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2010 08:11 AM, Geert Uytterhoeven wrote:
> On Wed, Jul 21, 2010 at 06:52, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> The patch below updates a broken web address.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   Documentation/fb/framebuffer.txt |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/fb/framebuffer.txt b/Documentation/fb/framebuffer.txt
>> index fe79e3c..58c5ae2 100644
>> --- a/Documentation/fb/framebuffer.txt
>> +++ b/Documentation/fb/framebuffer.txt
>> @@ -330,7 +330,7 @@ and on its mirrors.
>>
>>   The latest version of fbset can be found at
>>
>> -    http://home.tvd.be/cr26864/Linux/fbdev/
>
> FWIW, that exact same page has been at
> http://users.telenet.be/geertu/Linux/fbdev/
> for the last 4 years (when I had to change ISP). But the contents
> haven't changed.
>
>> +    http://www.linux-fbdev.org/
>
>   Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
>


ahh.. cool... thanks for this.. I need to go back and look through that 
series to do some fixups(there's was also another one that needs 
changing, but need to look through my old emails to find it(updated my 
OS so things are in kind of a scramble))


Justin P. Mattock

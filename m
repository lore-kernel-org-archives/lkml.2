Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0C1TIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 15:08:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61474 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab0C1TIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 15:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Dz4Q5M2g2lEBJb9pwmAtxeL5sOuXNVm1HxVbzwJLU5pAbr2qXIqdzXRGolO1aa/31f
         z51nCI1YdynSUKEAjNmj8wQtKKhhMGq5YIkFa8Xczs68ssiYNzmLp8mC22xz7zTBw4kX
         JVS4L/m6bkjlK58gCWxn614umM8f7YyhlJdbw=
Message-ID: <4BAFA939.7080000@gmail.com>
Date: Sun, 28 Mar 2010 12:08:41 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Rename imacfb.txt to efifb.txt and change imacfb to 
 efifb.
References: <1269798210-8664-1-git-send-email-justinmattock@gmail.com> <10f740e81003281154i4885f559s3f6ac79f1e697a3e@mail.gmail.com>
In-Reply-To: <10f740e81003281154i4885f559s3f6ac79f1e697a3e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2010 11:54 AM, Geert Uytterhoeven wrote:
> On Sun, Mar 28, 2010 at 19:43, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> Rename imacfb.txt to efifb.txt since imacfb was moved to
>> efifb,and change imacfb to efifb.
>> Note:I used git rm for imacfb.txt, but
>> git renamed this file to efifb.txt after everything was said and
>> done, not sure if this is correct or not.
>
> Git doesn't track renames. It just notices a new file is very similar
> (in this case identical)
> to a deleted one.
>
> Gr{oetje,eeting}s,
>
> 						Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
>

that's what happened i.g. I did git rm imacfb.txt
then did a git add efifb.txt
then git commit
then git said rename in the end

I've never submitted an add/delete so hopefully
this is o.k.

Justin P. Mattock

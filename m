Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab0CTMwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 08:52:51 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57298 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0CTMwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 08:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=G8pa6V8XhJYOOKWcY1fxhWuShbvlBDaD3+sT8mOD+ZFo7cCWjuuu5hyvzbtSByTRl4
         h1DOSLb6DLQTWj2GXLAvVg7zGzRoU1O3vcN9IjcgZf4tLsqnXpwNfGgDtamAHct9CMKF
         X0b4c7duAEDVSFeKt0M5tWqRBx7XZhhAQanuk=
Message-ID: <4BA4C52D.6020607@googlemail.com>
Date: Sat, 20 Mar 2010 13:53:01 +0100
From: Frank Schaefer <fschaefer.oss@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] x86: add HPET-quirk for nVidia MCP61 LPC Bridge
 (10de:03e0)
References: <4BA3963D.5000001@googlemail.com> <4BA3A517.4010307@ladisch.de>
In-Reply-To: <4BA3A517.4010307@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch schrieb:
> Frank Schaefer wrote:
>   
>> Any comments on this patch ?
>>     
> Gmail ate your tabs; see Documentation/email-clients.txt.
>   
Thanks for your reply Clemens.
It wasn't Gmails fault, I made a pasting mistake...sorry.
> Cosmetic changes to not belong in the stable tree; see
> Documentation/stable_kernel_rules.txt.
>   
Alright, no Cc stable.
>> Wrong list ?
>>     
>
> arch/x86 stuff should go to <x86@kernel.org>.
>
>
> Regards,
> Clemens
>   
The get-maintainer-script told me to send it to this list. Shouldn't it
be updated then ?
Also: this list seems to be mentioned nowhere, at least not at

http://www.linux.org/docs/lists.html
http://vger.kernel.org/vger-lists.html


Regards,
Frank

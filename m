Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0EGIrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:47:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38216 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab0EGIrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rUcF9BTKmta3l+p4Pt8VPwl8BKOPWM+k/c5Zm2TV2/1FShURRXavzFDeaG7JfRm4Z7
         a1CryxpSXGddg0c+Zgvy6Q2ziWyV78n1gASVIuY0ggJeJzqTXz6C5wivgY91gHsW5SC8
         +qYeO+cxvsl/uZFcT4zOZo7Bc2sHY67zsWO0w=
Message-ID: <4BE3D394.3030703@gmail.com>
Date: Fri, 07 May 2010 01:47:16 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Lex Hider <floss@lex.hider.name>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: monitor fails to sleep/suspend, forced to reboot
 to 	correct. 2.6.34-rc6
References: <AANLkTingM7EsCtbElXTNzzjZt4kG5acQtbt5mJEIVbrW@mail.gmail.com> <AANLkTiku49O-IKX0NwDtUoDEQyRT2VPcKiNVrSMbOR38@mail.gmail.com> <4BE3D03F.2010705@gmail.com>
In-Reply-To: <4BE3D03F.2010705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 01:33 AM, Justin P. Mattock wrote:
>
>> Can you do a bisect?
>> (2.6.32 - HEAD shouldn't
>> take too long).
>>
>> Justin P. Mattock
>>
>>
>> I'm still a git newbie. What specific command should I run and what
>> output to post?
>> You want me to do it against HEAD vs "latest known working version"?
>>
>> Thanks,
>>
>> Lex.
>> --
> sure.. it's easy(just requires patience).
>
> do a:(in the source tree of kernel)
> gist bisect start (enter)
> git bisect bad (v2.6.*something, and/or enter for the current)
> then
> git bisect good v2.6.33
> (git bisect will think)
> then
> make menuconfig
> make (compile, reboot etc..)
> if it's a good kernel then
> (in source tree)
> git bisect bad(if the problem is still there git bisect bad).
Oops typo I should of said:
git bisect bad(if the problem is still there, and if it's good
git bisect good (then make(compiling), reboot, then:
> then
> keep going until git gives it's idea of the problem
> (then cry and complain to the authors that they fu*ked it up
> just messn);
>
> hope this help.
>
> Justin P. Mattock

was looking for the wiki for you, but Google
came up with a bunch of crap.
(will look for that in the morning etc..)

Justin P. Mattock

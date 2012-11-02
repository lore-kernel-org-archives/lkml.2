Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab2KBQYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:24:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62758 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759374Ab2KBQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:24:07 -0400
Message-ID: <5093F390.2090809@gmail.com>
Date: Fri, 02 Nov 2012 12:23:44 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz> <1350592007-9216-22-git-send-email-jslaby@suse.cz> <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz> <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com> <5091448D.3@suse.cz> <CA+1xoqdRBCQYBQdK-=KJohtua_wD_fp4akk6_jS0x3x82fRp5g@mail.gmail.com> <5093EC1B.2050800@suse.cz> <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com> <5093F262.6000301@suse.cz>
In-Reply-To: <5093F262.6000301@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 12:18 PM, Jiri Slaby wrote:
> On 11/02/2012 05:07 PM, Sasha Levin wrote:
>> On Fri, Nov 2, 2012 at 11:51 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>> On 10/31/2012 04:59 PM, Sasha Levin wrote:
>>>> So you probably want a lot more than 100k syscalls, why limit it at
>>>> all actually?
>>>
>>> I unset the limit but I still can't reproduce...
>>>
>>>> I've attached my .config for the guest kernel as reference.
>>>
>>> Even using this config does not help to reproduce that.
>>>
>>> Do you use some special trinity params?
>>
>> Not really:
>>
>>     ./trinity -m --quiet --dangerous -l off
> 
> Oh, you run that as root??

Yup, it runs inside a disposable VM.


Thanks,
Sasha

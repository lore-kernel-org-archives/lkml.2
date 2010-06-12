Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0FLIov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 04:44:51 -0400
Received: from tpa-qmail.dyxnet.com ([152.104.96.30]:45103 "HELO
	tpa-qmailr1.dyxnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753190Ab0FLIot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 04:44:49 -0400
X-DYX-POP3-Checked-Auth: 114.32.100.136:kernel@takeo.idv.tw
Message-ID: <F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1>
From: "Takeo Tung" <kernel@takeo.idv.tw>
To: "Michal Marek" <mmarek@suse.cz>
Cc: <linux-kernel@vger.kernel.org>, "Christoph Hellwig" <hch@lst.de>,
       <kernel@takeo.idv.tw>
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1> <4C129778.7040409@suse.cz>
In-Reply-To: <4C129778.7040409@suse.cz>
Subject: Re: linux-next-20100608 will /bin/sh: scripts/basic/fixdep: Permission denied
Date: Sat, 12 Jun 2010 16:44:48 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

yes.

1. I complier liux-next-20100608 kernel, and boot the linux-next-20100608 
kernel, and try re-complier kernel, will found this message.
    /bin/sh: scripts/basic/fixdep: Permission denied

2. reboot other safe kernel, and revert the above patch, and complier it, 
and boot the new kernel, seems no this error.
    but I don't know why, bcoz seems code is ok.

Thanks,
Takeo Tung

--------------------------------------------------
From: "Michal Marek" <mmarek@suse.cz>
Sent: Saturday, June 12, 2010 4:07 AM
To: "Takeo Tung" <kernel@takeo.idv.tw>
Cc: <linux-kernel@vger.kernel.org>; "Christoph Hellwig" <hch@lst.de>
Subject: Re: linux-next-20100608 will /bin/sh: scripts/basic/fixdep: 
Permission denied

> On 11.6.2010 17:13, Takeo Tung wrote:
>> Dear All,
>>
>> I using linux-next-20100608 kernel, but if re-complier the kernel will
>> found
>> this messages.
>>
>> root@kernel-x86:/usr/src/linux# make oldconfig
>>  HOSTCC  scripts/basic/fixdep
>> /bin/sh: scripts/basic/fixdep: Permission denied
>> make[1]: *** [scripts/basic/fixdep] Error 1
>> make: *** [scripts_basic] Error 2
>>
>> But if I revert this patch, seems all back to normal, pls help me this is
>> bug patch or need adjust some system config?
>>
>> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=9d9b938248736826e86db9b16a3b435bdb5d649f
>
> Do I understand it correctly that you can't rebuild your kernel if
> you're running linux-next-20100608 and that the problem goes away if you
> revert the above patch, recompile somewhere else and boot the new
> kernel? I.e. it's unlikely a problem with fixdep itself?
>
> Adding Christoph Hellwig to cc.
>
> Michal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> 

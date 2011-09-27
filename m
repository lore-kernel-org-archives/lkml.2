Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1I0QyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:54:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51851 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1I0QyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:54:11 -0400
Message-ID: <4E81FFC4.7080508@oracle.com>
Date: Tue, 27 Sep 2011 09:54:28 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101215 CentOS/3.1.7-4 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/LAF_1309888596830-328557394 Thunderbird/3.1.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
References: <s5hmxdzyyzx.wl%tiwai@suse.de>	<201109212048.23074.rjw@sisk.pl>	<CAE9FiQVy4D0NhaN=PvPK_+L4Jv=+7huLy9U--LYW49GFZ9TyaQ@mail.gmail.com>	<s5hty84fnv7.wl%tiwai@suse.de>	<4E813464.80105@oracle.com> <s5hmxdqc546.wl%tiwai@suse.de>
In-Reply-To: <s5hmxdqc546.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090201.4E81FF6D.00B9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 09:38 AM, Takashi Iwai wrote:
>>
>>> Any hint for further debugging?
>>
>>
>> you may try to insert dead loop in arch/x86/power/hibernate_asm_64.S::restore_image or core_restore_code
>>
>> to see which part cause reset.
>
> That's the answer I was afraid of :)
>

haha, because that time console port is away?

or if you have debug card with port 80 LED, you can add delay and output 
some code there.

BTW, can you post detail sequence and log ?
I could try if i can duplicate in my setups.

Thanks

Yinghai

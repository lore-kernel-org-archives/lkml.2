Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab1DMBad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:30:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55312 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab1DMBaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r8Lc7lBULSOGeF8b4bz4HwY0NWDfPaXMQVEX2+5/yZOctBDVNQM7CtekPMclOemccq
         C07Uuu4ri3BxA2Y3J437ZD3GmKMnem414/trwwL2S3yESPOZ5J6kL+fF2XMI0UEWZ79l
         qrrF/scqzMlFfCQ83nalEFPsidxK0c3ERT/lM=
Message-ID: <4DA4FCAF.8080408@gmail.com>
Date: Tue, 12 Apr 2011 18:30:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>
Subject: =?windows-1252?Q?Re=3A_=5BRFC=5DDocumentation=3Aaccounting=3Ag?=
 =?windows-1252?Q?etdelays=2Ec_Fix=3A_warning=3A_variable_=91i=92?=
 =?windows-1252?Q?_set_but_not_used?=
References: <1302019370-7101-1-git-send-email-justinmattock@gmail.com>	<20110412172627.4e9c4339.akpm@linux-foundation.org>	<4DA4F201.9050609@gmail.com> <20110412181821.93a3a17f.akpm@linux-foundation.org>
In-Reply-To: <20110412181821.93a3a17f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 06:18 PM, Andrew Morton wrote:
> On Tue, 12 Apr 2011 17:44:49 -0700 "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> On 04/12/2011 05:26 PM, Andrew Morton wrote:
>>> On Tue,  5 Apr 2011 09:02:50 -0700
>>> "Justin P. Mattock"<justinmattock@gmail.com>   wrote:
>>>
>>>> Keep in mind there is another warning with this file, but need am unsure what might be the best solution:
>>>> Documentation/accounting/getdelays.c: In function ___get_family_id___:
>>>> Documentation/accounting/getdelays.c:172:14: warning: variable ___rc___ set but not used [-Wunused-but-set-variable]
>>>
>>> this?
>>
>> there was two warnings with that one..(or atleast that what I am seeing
>> over here).
>
> I don't know what you mean.
>
> What command(s) are you using to build getdelays.o, btw?
>

the two warnings while building getdelays
to build the kernel I just do:
"make"

part of the log here:
http://fpaste.org/eXmq/

system is fedora 15. .config is theirs as well

Justin P. Mattock
